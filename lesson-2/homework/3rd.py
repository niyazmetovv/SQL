import pyodbc

con_str = "DRIVER={ODBC Driver 17 for SQL Server};SERVER={WIN-D4PFV0TD39H\SQLEXPRESS};DATABASE=lessons;Trusted_Connection=yes;"
con = pyodbc.connect(con_str)

cursor = con.cursor()
cursor.execute("SELECT * FROM photos")

row = cursor.fetchone()
if row:
 id, image = row
 if image:

  with open("test.jpg", "wb") as img:
    img.write(image)
con.close()



