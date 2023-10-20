#!/usr/bin/env bash

DATA=`cat /docker-entrypoint-initdb.d/mongo.json`
mongosh -- "$MONGO_INITDB_DATABASE"<<EOF

var rootUser = '$MONGO_INITDB_ROOT_USERNAME';
var rootPassword = '$MONGO_INITDB_ROOT_PASSWORD';
 
var admin = db.getSiblingDB('admin');

admin.auth(rootUser, rootPassword);

var user = '$MONGO_INITDB_ROOT_USERNAME';
var passwd = '$MONGO_INITDB_ROOT_PASSWORD';

db.createUser(
  {
    user: user,
    pwd:  passwd,
    roles: [
        { role: "readWrite" , db: '$MONGO_INITDB_DATABASE'}
    ]
  },
  {
    user: user,
    pwd:  passwd,
    roles: [
        { role: "readWrite" , db: 'rocketchat'}
    ]
  }
  {
    user: user,
    pwd:  passwd,
    roles: [
        { role: "readWrite" , db: 'local'}
    ]
  }
)

// make client_id unique
db.client.createIndex( { "client_id": 1 }, { unique: true } )
db.client.createIndex( { "registration_access_token": 1 }, { unique: true } )

// make access_token and sid unique
db.session.createIndex( { "sid": 1 }, { unique: true } )

// create expired session deletion
db.session.createIndex(
  { expires_at: 1 },
  { expireAfterSeconds: 0, partialFilterExpression: { count: { \$gt: 2 } } }
);

// insert a test client like this
db.client.insertMany($DATA)

EOF

