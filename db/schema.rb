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

ActiveRecord::Schema.define(version: 20150701191603) do

  create_table "bancos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bodegas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "almacen_id"
    t.string   "tipo"
  end

  create_table "clientes", force: :cascade do |t|
    t.integer  "cliente_id"
    t.string   "nombre"
    t.string   "direccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compra_b2_bs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fabricacions", force: :cascade do |t|
    t.date     "fecha"
    t.string   "sku"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cantidad"
  end

  create_table "ftp_managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oc_managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pedidos", force: :cascade do |t|
    t.string   "sku"
    t.integer  "cantidad"
    t.decimal  "precio_unitario"
    t.string   "direccion"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "cantidadDespachada"
    t.string   "estado"
    t.string   "fechaEntrega"
    t.string   "order_id"
    t.boolean  "ftp"
    t.boolean  "ecommerce"
  end

  create_table "product_infos", force: :cascade do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.string   "img"
    t.decimal  "precio"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "product_id"
    t.integer  "sku"
  end

  create_table "productos", force: :cascade do |t|
    t.string   "prod_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promo_managers", force: :cascade do |t|
    t.string   "sku"
    t.string   "precio"
    t.string   "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promocions", force: :cascade do |t|
    t.string   "sku"
    t.string   "precio"
    t.string   "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "inicio"
    t.date     "fin"
  end

  create_table "transaccions", force: :cascade do |t|
    t.string   "monto"
    t.string   "destino"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "fecha"
  end

  create_table "transitos", force: :cascade do |t|
    t.boolean  "azucar",       default: false
    t.boolean  "madera",       default: false
    t.boolean  "celulosa",     default: false
    t.boolean  "chocolate",    default: false
    t.boolean  "pasta_semola", default: false
    t.boolean  "semola",       default: false
    t.boolean  "sal",          default: false
    t.boolean  "huevo",        default: false
    t.boolean  "cacao",        default: false
    t.boolean  "leche",        default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "token"
    t.datetime "token_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "users", ["token"], name: "index_users_on_access_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
