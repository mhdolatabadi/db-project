const mysql = require('mysql')
const express = require('express')

const app = express()
const port = 3000

app.use(express.json()) // for parsing application/json

app.listen(port, () => {
  console.log(`server listening at port: ${port}`)
})

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'MoHo791818',
  database: 'Phase3',
})

db.connect(function (err) {
  if (err) throw err
  console.log('Connected!')
})

var sql = 'Select * from Address'
db.query(sql, function (err, result) {
  if (err) throw err
  console.log(result)
})

app.get('/', (req, res) => {
  const { body, parameters } = req.query
  res.header('Access-Control-Allow-Origin', '*')
  db.query(body, parameters, function (err, result) {
    if (err) res.send(err)
    res.send(result)
  })
})

// insert into Personnel values('111', 'M' , 'D' , null , null ,  0, '6037697508102875', '2008-11-11', null)
