# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20150515202520) do
=======
ActiveRecord::Schema.define(version: 20150516194603) do
>>>>>>> pauli_juan

  create_table "bodegas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
<<<<<<< HEAD
=======
    t.string   "almacen_id"
    t.string   "tipo"
>>>>>>> pauli_juan
  end

  create_table "clientes", force: :cascade do |t|
    t.string   "nombre"
    t.string   "direccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pedidos", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "sku"
    t.integer  "cantidad"
    t.decimal  "precio_unitario"
    t.string   "direccion"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end
<<<<<<< HEAD
=======

  create_table "productos", force: :cascade do |t|
    t.string   "prod_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
>>>>>>> pauli_juan

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "token"
    t.boolean  "token_active"
    t.datetime "token_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "users", ["token"], name: "index_users_on_access_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
