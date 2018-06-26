#holds the function that makes the pdf
class PdfMaker
  def self.make(data:, path:)
    tenant = data.tenant
    invoice = data.invoice
    #customer_name = invoice.customer_name
    path = Dir.pwd + '/invoice.pdf'
    #first_page_items = invoice.items.first(12)

    pdf = Prawn::Document.new

    PdfMaker.setup_fonts(pdf)

    PdfMaker.put_text(pdf, 'my first page')

    PdfMaker.put_page(pdf, 'Hello page 1')
    PdfMaker.put_page(pdf, 'Hello page 2')

    pdf.render_file path
  end

  def self.setup_fonts(pdf)
    pdf.font_families.update(
      'Lato' => {
        normal: { file: "#{Dir.pwd}/fonts/Lato-Light.ttf", font: 'Lato-Regular' },
        bold: { file: "#{Dir.pwd}/fonts/Lato-Black.ttf", font: 'Lato-Bold' }
      }
    )

    pdf.font 'Lato' # t
  end

  def self.put_page(pdf, text)
    pdf.start_new_page
    PdfMaker.put_text(pdf, text)
  end

  def self.put_text(pdf, text)
    pdf.text text
  end
#
end

#     Prawn::Document.generate(path, page_size: 'LETTER', page_layout: :portrait) do |pdf|
#       #This is where the font is defined
#       pdf.font_families.update(
#         'Lato' => {
#           normal: { file: "#{Dir.pwd}/fonts/Lato-Light.ttf", font: 'Lato-Regular' },
#           bold: { file: "#{Dir.pwd}/fonts/Lato-Black.ttf", font: 'Lato-Bold' }
#         }
#       )
#
#       pdf.font 'Lato' # t
#
#
#       pdf.define_grid(columns: 10, rows: 16, gutter: 0)
#       #grid.show_all
#
#       # => THIS STAMP IS THE HEADER THAT SHOULD BE ON EACH PAGE
#       pdf.create_stamp('header') do
#         grid([0,0], [2, 3]).bounding_box do
#           begin
#             image open(tenant.logo.medium_url), fit:[150, 100]#[100, 60]
#           rescue StandardError # If the image cannot be loaded, show the name (Prawn will exception when unable to load)
#             text tenant.company_name, size: 16, style: :bold
#           end # END THE BEGIN RECUE
#           #stroke_bounds
#         end # ENDS THE GRID BOUNDING BOX ON LINE 50
#         grid([0,4], [2, 6]).bounding_box do
#           move_down 10
#           text "Remit Info"
#           if tenant.address && tenant.address.filled_in?
#             text tenant.company_name,overflow: :shrink_to_fit
#             text tenant.address.full_street, overflow: :shrink_to_fit
#             text tenant.address.city_state_zip, overflow: :shrink_to_fit
#             text tenant.address.phone_number, overflow: :shrink_to_fit
#             text tenant.address.email_address, overflow: :shrink_to_fit
#           end # END IF STATEMENT
#           #stroke_bounds
#         end # ENDS THE GRID BOUNDING BOX ON LINE 58
#         grid([0,7], [2, 9]).bounding_box do
#           move_down 10
#
#           text "INVOICE", size: 14, style: :bold, overflow: :shrink_to_fit
#           move_down 10
#
#           text "#{invoice.sales_order_number}", size: 36, style: :bold, overflow: :shrink_to_fit
#
#
#           #stroke_bounds
#         end # ENDS THE GRID BOUNDING BOX ON LINE 70
#
#         # grid([5,0], [5,9]).bounding_box do
#         #   stroke_bounds
#         # end
#
#
#       end # STAMP FOR HEADER ON LINE 49
#
#       # => THIS IS THE STAMP THAT PUTS GENERAL INFO ON FIRST PAGE
#       pdf.create_stamp('Gen_Info') do
#           grid([3,0],[4,2]).bounding_box do
#             #stroke_bounds
#             move_down 15
#             bill = 'Bill to: ' + invoice.billing_address.name
#             text bill, overflow: :shrink_to_fit
#             text invoice.billing_address.full_street, overflow: :shrink_to_fit
#             text invoice.billing_address.city_state_zip, overflow: :shrink_to_fit
#             text invoice.billing_address.phone_number, overflow: :shrink_to_fit
#           end # ENDS THE GRID BOUNDING BOX ON LINE 86
#           grid([3,3],[4,5]).bounding_box do
#             #stroke_bounds
#             move_down 15
#             ship = "Ship to: " + invoice.shipping_address.name
#             text ship, overflow: :shrink_to_fit
#             text invoice.shipping_address.full_street, overflow: :shrink_to_fit
#             text invoice.shipping_address.city_state_zip, overflow: :shrink_to_fit
#             text invoice.shipping_address.phone_number, overflow: :shrink_to_fit
#           end # ENDS THE GRID BOUNDING BOX ON LINE 94
#           grid([3,6],[4,9]).bounding_box do
#             #stroke_bounds
#             define_grid(columns: 3, rows: 1, gutter: 0)
#             #grid.show_all
#               grid(0,0).bounding_box do
#                 #stroke_bounds
#                 move_down 15
#                 text "Date", align: :center
#                 move_down 5
#                 text invoice.invoice_date, align: :center, size: 14, style: :bold
#                 text invoice.invoice_year, align: :center, size: 12, style: :bold
#               end # ENDS THE GRID BOUNDING BOX ON LINE 106
#               grid(0,1).bounding_box do
#                 stroke_bounds
#                 #fill
#                 move_down 15
#                 text "Due", align: :center
#                 move_down 5
#                 text invoice.due_on, align: :center, size: 14, style: :bold
#                 text invoice.due_on_year, align: :center, size: 12, style: :bold
#               end # ENDS THE GRID BOUNDING BOX ON LINE 114
#
#               grid(0,2).bounding_box do
#                 #stroke_bounds
#                 move_down 15
#                 text "Amount", align: :center
#                 text "Due", align: :center
#                 move_down 5
#                 #text "$#{invoice.total}", align: :center, overflow: :shrink_to_fit
#                 text ActiveSupport::NumberHelper::number_to_currency(invoice.total), overflow: :shrink_to_fit, align: :center
#               end # ENDS THE GRID BOUNDING BOX ON LINE 124
#           end # ENDS THE GRID BOUNDING BOX ON LINE 102
#
#         end # STAMP FOR Gen_Info ON LINE 84
#
#       pdf.define_grid(columns: 10, rows: 16, gutter: 0)
#       #grid.show_all
#       pdf.create_stamp("Item_header") do
#         grid([5,0], [5,4]).bounding_box do
#             #stroke_bounds
#             move_down 5
#             text "Item", style: :bold
#             text "Description"
#             stroke do
#               self.line_width = 4
#               stroke_color 250, 0, 0, 1
#               horizontal_line 0, 540, :at => cursor #y
#               # self.line_width = 1
#               # stroke_color "000000"
#             end
#         end
#         grid(5,5).bounding_box do
#             #stroke_bounds
#             move_down 5
#             text "QTY", align: :right, size: 14, style: :bold
#         end
#         grid([5,6], [5,7]).bounding_box do
#             #stroke_bounds
#             move_down 5
#             text "Price", align: :right, size: 14, style: :bold
#
#         end
#         grid([5,8], [5,9]).bounding_box do
#             #stroke_bounds
#             move_down 5
#             text "Total", align: :right, size: 14, style: :bold
#         end
#
#       end
#
#       create_stamp("Footer") do
#         grid([14,0],[15,6]).bounding_box do
#           #stroke_bounds
#         end
#         grid([14,7],[15,9]).bounding_box do
#           #stroke_bounds
#           define_grid(columns: 2, rows: 1, gutter: 10)
#           grid(0, 0).bounding_box do
#             # transparent(0.05) { stroke_bounds }
#             text 'Subtotal', style: :bold, overflow: :shrink_to_fit, size: 10
#             text 'Shipping', style: :bold, overflow: :shrink_to_fit, size: 10
#             text 'Tax', style: :bold, overflow: :shrink_to_fit, size: 10
#             text 'Discount', style: :bold, overflow: :shrink_to_fit, size: 10
#             text 'Total', style: :bold, overflow: :shrink_to_fit, size: 10
#             text 'Payments', style: :bold, overflow: :shrink_to_fit, size: 10
#             text 'Total Due', style: :bold, overflow: :shrink_to_fit, size: 10
#           end
#
#           grid(0, 1).bounding_box do
#             text ActiveSupport::NumberHelper::number_to_currency(invoice.subtotal), overflow: :shrink_to_fit, align: :right, size: 10
#             text ActiveSupport::NumberHelper::number_to_currency(invoice.shipping), overflow: :shrink_to_fit, align: :right, size: 10
#             text ActiveSupport::NumberHelper::number_to_currency(invoice.tax), overflow: :shrink_to_fit, align: :right, size: 10
#             text ActiveSupport::NumberHelper::number_to_currency(invoice.discount), overflow: :shrink_to_fit, align: :right, size: 10
#             text ActiveSupport::NumberHelper::number_to_currency(invoice.total), overflow: :shrink_to_fit, align: :right, size: 10
#             text ActiveSupport::NumberHelper::number_to_currency(0), overflow: :shrink_to_fit, align: :right, size: 10
#             text ActiveSupport::NumberHelper::number_to_currency(invoice.balance), overflow: :shrink_to_fit, align: :right, size: 10
#           end
#         end
#
#       end
#     define_grid(columns: 10, rows: 16, gutter: 0)
#     x = []
#     def putpages(invoice)
#       grid([6,0], [13,4]).bounding_box do
#         #stroke_bounds
#         invoice.items.each_with_index do |item| #|item, index|
#           x << cursor
#           #puts x
#           text "#{item.id} - #{item.title} ", overflow: :shrink_to_fit, size: 10 #{cursor}
#
#           text item.description, overflow: :shrink_to_fit, size: 8
#           stroke do
#             self.line_width = 1
#             stroke_color 250, 0, 0, 1
#             horizontal_line 0, 540, :at => cursor #y
#           end
#           move_down 4
#         end
#       end
#       # stroke do
#       #   self.line_width = 1
#       #   stroke_color "000000"
#       # end
#       grid([6,5], [13,5]).bounding_box do
#         #puts x
#         index = 0
#         #stroke_bounds
#         invoice.items_list.each_with_index do |item| #|item, index|
#           move_cursor_to x[index]
#           text ActiveSupport::NumberHelper::number_to_delimited(item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
#           index += 1
#         end
#       end
#       grid([6,6], [13,7]).bounding_box do
#         index = 0
#         #stroke_bounds
#         invoice.items_list.each_with_index do |item| #|item, index|
#           move_cursor_to x[index]
#           text ActiveSupport::NumberHelper::number_to_currency(item.price), overflow: :shrink_to_fit, align: :right, size: 10
#           index += 1
#         end
#       end
#       grid([6,8], [13,9]).bounding_box do
#         index = 0
#         #stroke_bounds
#         invoice.items_list.each_with_index do |item| #|item, index|
#           move_cursor_to x[index]
#           text ActiveSupport::NumberHelper::number_to_currency(item.price*item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
#           index += 1
#         end
#       end
#     end # end of page item function
#     def firstpage()
#         stamp 'header'
#         stamp 'Gen_Info'
#         stamp 'Item_header'
#         putpages()
#         stamp "Footer"
#     end
#       puts invoice.items_list.length
#       if invoice.items_list.length < 15
#         stamp 'header'
#         stamp 'Gen_Info'
#         stamp 'Item_header'
#         putpages(invoice)
#         stamp "Footer"
#       end
#
#
#     end
#   end
# end
