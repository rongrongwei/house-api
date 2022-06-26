from mysql.connector import pooling
from dbpassword import password # part of gitlab deployment
from dbhost import dbhost # part of gitlab deployment
import time
import json


connection_pool = None
fail_count = 0
sleep_time = 10
time.sleep(5) # give app a little head start :)
while connection_pool is None and fail_count < 10:
    try:
        connection_pool = pooling.MySQLConnectionPool(
            pool_name = "my_pool",
            pool_size = 3,
            pool_reset_session = True,
            # host = '10.152.183.6',
            host = dbhost,
            database = 'cs4783_tyw061',
            user = 'tyw061',        
            password = password   # Password is now in a Gitlab variable 
            # password = 'secret'
        )
    except Exception as e:
        print("Error while connecting to MySQL using Connection pool", e)

        fail_count += 1
        print(f"fail no: {fail_count} waiting {sleep_time} seconds...")
        time.sleep(sleep_time)

def get_all_properties():
    conn = connection_pool.get_connection()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute("select property_id, address, zip from property")
        records = cursor.fetchall()
        cursor.close()
        conn.close()

    all_properties = []
    for record in records:
        tmp = {"id" : record[0], "address" : record[1], "zip" : record[2]}
        all_properties.append(tmp)
    return all_properties

def post_property(post_dict):
    post_dict = json.loads(post_dict)
    valid_dict = {'address':(1,255), 'city':(1,50), 'state':(2,2), 'zip':(5,10)}

    # check keys
    for key in post_dict:
        if key not in valid_dict:
            return (f"{key} not a valid update key", 400) # TODO: handle this error
        elif len(post_dict[key]) < valid_dict[key][0] or len(post_dict[key]) > valid_dict[key][1]:
            return (f"{key} must be between {valid_dict[key][0]} and {valid_dict[key][1]} characters long", 400) 

    address, city, state, zip = post_dict['address'], post_dict['city'], post_dict['state'], post_dict['zip']

    conn = connection_pool.get_connection()
    if conn.is_connected():
        cursor = conn.cursor()
        insert_query = (
            """INSERT into property(address, city, state, zip)
            VALUES(%s, %s, %s, %s)"""
        )
        data = (address, city, state, zip)
        cursor.execute(insert_query, data)
        conn.commit()
        rows_changed = cursor.rowcount
        cursor.execute("SELECT LAST_INSERT_ID()")
        id_record = cursor.fetchone()
        cursor.close()
        conn.close()

    if rows_changed == 1:
        return (f"added id {id_record[0]}", 200)
    return ("failed to insert", 500)

def get_property_id(property_id):
    conn = connection_pool.get_connection()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute("select property_id, address, city, state, zip from property where property_id = %s", 
                       (property_id,))

        record = cursor.fetchone()
        rows_found = cursor.rowcount
        cursor.close()
        conn.close() 
    if rows_found <= 0:
        return {"message":"not found"}, 404

    id_property = {"id" : record[0], "address": record[1], "city": record[2], "state": record[3], "zip": record[4]}
    return id_property, 200

def delete_property_id(property_id):
    conn = connection_pool.get_connection()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute("DELETE FROM property WHERE property_id = %s", (property_id,))
        conn.commit()
        rows_changed = cursor.rowcount
        cursor.close()
        conn.close()
    return rows_changed

def put_property_id(property_id, update_dict):
    update_dict = json.loads(update_dict)
    conn = connection_pool.get_connection()
    valid_dict = {'address':(1,255), 'city':(1,50), 'state':(2,2), 'zip':(5,10)}

    # check keys
    for key in update_dict:
        if key not in valid_dict:
            return f"{key} not a valid update key", 400 # TODO: handle this error
        elif len(update_dict[key]) < valid_dict[key][0] or len(update_dict[key]) > valid_dict[key][1]:
            return f"{key} must be between {valid_dict[key][0]} and {valid_dict[key][1]} characters long", 400


    if conn.is_connected():
        cursor = conn.cursor()
        query = "UPDATE property SET " + ", ".join(key + ' = %s' for key in update_dict) + " WHERE property_id = %s"
        # ['address = %s', 'city = %s'] -> 'address = %s, city = %s'
        # "UPDATE property SET address = %s, city = %s WHERE property_id = %d"
        value_list = [str(update_dict[key]) for key in update_dict] + [property_id]
        cursor.execute(query, value_list)
        conn.commit()
        rows_changed = cursor.rowcount
        cursor.close()
        conn.close()
    
    if rows_changed == 1:
        return "updated", 200
    else:
        _, status = get_property_id(property_id)
        if status == 200:
            return "bad request/no updates made", 400
    return "not found", 404
