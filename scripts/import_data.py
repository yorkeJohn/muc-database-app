import json

parts = json.load(open('parts_100.json', 'r'))
suppliers = json.load(open('suppliers_100.json', 'r'))
orders = json.load(open('orders_4000.json', 'r'))

for p in parts:
    print("INSERT INTO parts (PartID, Price, Description) VALUES ('%s', '%s', '%s');" % tuple(p.values()))

for s in suppliers:
    print("INSERT INTO suppliers (SupplierID, Name, Email) VALUES ('%s', '%s', '%s');" % tuple(s.values())[0:3])
    for t in s['tel']:
        print(f"INSERT INTO supplier_phones (PhoneNumber, SupplierID) VALUES ('{t['number']}', {s['_id']});")

for id, o in enumerate(orders):
    print(f"INSERT INTO orders (OrderID, SupplierID, Date) VALUES ({id + 1}, {o['supp_id']}, '{o['when']}');")
    for i in o['items']:
        print(f"INSERT INTO order_parts (OrderID, PartID, Quantity) VALUES ({id + 1}, {i['part_id']}, {i['qty']}) ON DUPLICATE KEY UPDATE Quantity=Quantity+{i['qty']};")