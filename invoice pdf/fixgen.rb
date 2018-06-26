require 'json'
require 'ostruct'
require 'prawn'
require 'active_support'
require 'open-uri'
require 'pry'

require_relative 'pdf_create'
require_relative 'data'
data = DATA.to_json
data = JSON.parse(data, object_class: OpenStruct)
#
# tenant = data.tenant
# invoice = data.invoice
# customer_name = invoice.customer_name
path = Dir.pwd + '/invoice.pdf'
# first_page_items = invoice.items.first(12)
#link = "https://99percentinvisible.org/app/uploads/2017/03/nike-and-target-logos.jpg"

pdf_maker = PdfMaker.new(data: data, path: path)
pdf_maker.make
