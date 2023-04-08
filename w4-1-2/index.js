import { open } from 'sqlite'
import sqlite3 from 'sqlite3'
import { main } from './listenEvents.js'
open({
  filename: './database.db',
  driver: sqlite3.Database,
}).then(db=>{
  return main(db)
})