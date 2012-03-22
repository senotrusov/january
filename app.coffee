#!/usr/bin/env coffee

#  Copyright 2010-2012 Stanislav Senotrusov <stan@senotrusov.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


pg = require('pg').native

conString = 'tcp://january@localhost/january' # password is stored in ~/.pgpass
pg.defaults.poolSize = 30

connect = require 'connect' # https://github.com/senchalabs/connect
http    = require 'http'

env       = process.env.NODE_ENV ? 'development';
cookieKey = require('fs').readFileSync('config/cookie.key', 'utf8').trim()


app = connect()

if env != 'production'
  app.use connect.favicon()
  app.use connect.logger 'dev'
  app.use connect.static 'public'

app.use connect.cookieParser cookieKey
app.use connect.cookieSession cookie: maxAge: 1000 * 60 * 60 * 24 * 365 # time in milliseconds, 1 year
app.use connect.bodyParser()
app.use connect.csrf()

app.use (req, res) ->
  pg.connect conString, (err, client) ->
    if err
      console.log err
      process.exit 1
    else
      client.query "SELECT * FROM paragraphs WHERE id = 1", (err, result) ->
        if err
          console.log err
          process.exit 1 # TODO: pg pool prevents process from exit
        else
          req.session.count ?= 0
          req.session.count += 1

          res.end "#{result.rows[0].message} #{req.session.count}\n"
              
http.createServer(app).listen 3000

