#!/usr/bin/env python

# This is just an app to create a table, load data, and then repeatedly  query it,
# printing the results.
#
# Ref. https://stackoverflow.com/questions/372885/how-do-i-connect-to-a-mysql-database-in-python
#
# Requires: pip install pymysql peewee
import time
import datetime
import peewee
from peewee import *

t_sleep_sec = 2

# TODO: fill in from VCAP_SERVICES or service key
db = None
n_tries = 0
while db is None and n_tries < 3:
  try:
    db = MySQLDatabase(
      "service_instance_db",
      user="7f2293e42696413080d761da1d8eb592",
      passwd="116qd2knfmmoolbq",
      host="127.0.0.1",
      port=13306
    )
  except:
    n_tries += 1

class Book(peewee.Model):
  author = peewee.CharField()
  title = peewee.TextField()
  class Meta:
    database = db

if not Book.table_exists():
  Book.create_table()
Book.truncate_table()

# Insert some books
book = Book(author="Marcel Proust", title="In Search of Lost Time")
book.save()
book = Book(author="Miguel de Cervantes", title="Don Quixote")
book.save()
book = Book(author="James Joyce", title="Ulysses")
book.save()
book = Book(author="F. Scott Fitzgerald", title="The Great Gatsby")
book.save()
book = Book(author="Herman Melville", title="Moby Dick")
book.save()
book = Book(author="Leo Tolstoy", title="War and Peace")
book.save()
book = Book(author="Gustave Flaubert", title="Madame Bovary")
book.save()
book = Book(author="Mark Twain", title="The Adventures of Huckleberry Finn")
book.save()

while True:
  print "[" + str(datetime.datetime.now()) + "]"
  #for book in Book.filter(author="me"):
  for book in Book.select():
    print "Author: %s, Title: %s" % (book.author, book.title)
  print ""
  time.sleep(t_sleep_sec)

