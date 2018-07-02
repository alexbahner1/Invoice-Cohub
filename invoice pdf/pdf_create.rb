class PdfMaker
  attr_accessor :data, :path
  attr_reader :tenant, :invoice, :pdf

  def initialize(data:, path:)
    @data = data
    @path = path
    @tenant = data.tenant
    @invoice = data.invoice
    @stamp_count = 0
    @addfoot = false
  end

  def make
    @pdf = Prawn::Document.new
    setup_fonts

    if invoice.items.length < 15
      only_page
    else
      first_page
      put_items_next
      page_number
    end

    pdf.render_file path
  end

  private

  def only_page
    header
    gen_info
    item_header_first
    put_items
    footer
    page_number
  end

  def first_page
    header
    gen_info
    item_header_first
    put_items
    #page_number
  end

  def setup_fonts
    pdf.font_families.update(
      'Lato' => {
        normal: { file: "#{Dir.pwd}/fonts/Lato-Light.ttf", font: 'Lato-Hairline' },
        bold: { file: "#{Dir.pwd}/fonts/Lato-Black.ttf", font: 'Lato-LightItalic' }
      }
    )

    pdf.font 'Lato' # t
  end

  def header
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    #pdf.grid.show_all

    # => THIS STAMP IS THE HEADER THAT SHOULD BE ON EACH PAGE
    stamp_name = next_stamp("Header")
    pdf.create_stamp(stamp_name) do
      pdf.grid([0,0], [2, 3]).bounding_box do
        begin
          pdf.move_down 10
          pdf.image open(tenant.logo.medium_url), fit:[150, 100]#[100, 60]
        rescue StandardError # If the image cannot be loaded, show the name (Prawn will exception when unable to load)
          pdf.text tenant.company_name, size: 16, style: :bold
        end # END THE BEGIN RECUE
        #stroke_bounds
      end # ENDS THE GRID BOUNDING BOX ON LINE 50
      pdf.grid([0,4], [2, 6]).bounding_box do
        pdf.move_down 10
        pdf.text "Remit To:", style: :bold
        if tenant.address && tenant.address.filled_in?
          pdf.text tenant.company_name,overflow: :shrink_to_fit
          pdf.text tenant.address.full_street, overflow: :shrink_to_fit
          pdf.text tenant.address.city_state_zip, overflow: :shrink_to_fit
          pdf.text tenant.address.phone_number, overflow: :shrink_to_fit
          pdf.text tenant.address.email_address, overflow: :shrink_to_fit
        end # END IF STATEMENT
        #stroke_bounds
      end # ENDS THE GRID BOUNDING BOX ON LINE 58
      pdf.grid([0,7], [2, 9]).bounding_box do
        pdf.move_down 10

        pdf.text "INVOICE", size: 14, style: :bold, overflow: :shrink_to_fit
        pdf.move_down 10

        pdf.text "#{invoice.sales_order_number}", size: 36, style: :bold, overflow: :shrink_to_fit

        pdf.text "<u><link href='https://tapeonline.com/'>PAY HERE" + "</link></u>", :inline_format => true

        #stroke_bounds
      end # ENDS THE GRID BOUNDING BOX
    end # STAMP FOR HEADER
    pdf.stamp stamp_name
    #page_number
  end

  def gen_info
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    #pdf.grid.show_all
    # => THIS IS THE STAMP THAT PUTS GENERAL INFO ON FIRST PAGE
    stamp_name = next_stamp("GeneralInfo")
    pdf.create_stamp(stamp_name) do
        pdf.grid([3,0],[4,2]).bounding_box do
          # pdf.stroke_bounds
          pdf.stroke do
            pdf.line_width = 1
            pdf.horizontal_line 0, 540, :at => pdf.cursor #y
          end
          pdf.move_down 5
          #original_y = pdf.cursor
          pdf.text 'Bill to: ', style: :bold, size: 10
          #pdf.move_cursor_to original_y
          #pdf.indent(38) do
          pdf.text invoice.billing_address.name, size: 10, overflow: :shrink_to_fit
          #end
          if invoice.billing_address.co == true
            pdf.text invoice.billing_address.company, size: 10, overflow: :shrink_to_fit
          end
          pdf.text invoice.billing_address.full_street, size: 10, overflow: :shrink_to_fit
          pdf.text invoice.billing_address.city_state_zip, size: 10, overflow: :shrink_to_fit
          pdf.text invoice.billing_address.phone_number, size: 10, overflow: :shrink_to_fit
        end # ENDS THE GRID BOUNDING BOX ON LINE 86
        pdf.grid([3,3],[4,5]).bounding_box do
          # pdf.stroke_bounds
          pdf.move_down 5
          #original_y = pdf.cursor
          pdf.text "Ship to: ", style: :bold, size: 10
          #pdf.move_cursor_to original_y
          #pdf.indent(45) do
          pdf.text invoice.shipping_address.name, size: 10, overflow: :shrink_to_fit
          #end
          if invoice.shipping_address.co == true
            pdf.text invoice.shipping_address.company, size: 10, overflow: :shrink_to_fit
          end
          pdf.text invoice.shipping_address.full_street, size: 10, overflow: :shrink_to_fit
          pdf.text invoice.shipping_address.city_state_zip, size: 10, overflow: :shrink_to_fit
          pdf.text invoice.shipping_address.phone_number, size: 10, overflow: :shrink_to_fit
        end # ENDS THE GRID BOUNDING BOX ON LINE 94
        pdf.grid([3,6],[4,9]).bounding_box do
          #pdf.stroke_bounds

          pdf.define_grid(columns: 3, rows: 1, gutter: 0)
          #pdf.grid.show_all
          #pdf.stroke_axis
          mv = 8
          md = 3
            pdf.grid(0,0).bounding_box do
              #pdf.stroke_bounds
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 20) do
                pdf.stroke_bounds
                pdf.fill_color 'C0C0C0'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 20
                pdf.fill
                pdf.move_down mv - md

                pdf.text "Invoice Date", size: 10, align: :center, style: :bold, :color => ('000000') #('FFFFFF')

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 25) do
                pdf.stroke_bounds
                pdf.fill_color 'FFFFFF'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 25
                pdf.fill
                pdf.move_down mv

                pdf.text invoice.invoice_date, size: 10, align: :center, :color => '000000', overflow: :shrink_to_fit

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 20) do
                pdf.stroke_bounds
                pdf.fill_color 'C0C0C0'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 20
                pdf.fill
                pdf.move_down mv - md

                pdf.text "Order Date", :color => ('000000'), size: 10, align: :center, style: :bold#('FFFFFF')

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 25) do
                pdf.stroke_bounds
                pdf.fill_color 'FFFFFF'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 25
                pdf.fill
                pdf.move_down mv

                pdf.text invoice.order_date, size: 10, align: :center, :color => '000000', overflow: :shrink_to_fit

              end
            end # ENDS THE GRID BOUNDING BOX ON LINE 106
            pdf.grid(0,1).bounding_box do
              #pdf.stroke_bounds

              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 20) do
                pdf.stroke_bounds
                pdf.fill_color 'C0C0C0' #'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 20
                pdf.fill
                pdf.move_down mv - md

                pdf.text "Due Date", size: 10, align: :center, style: :bold, :color => ('000000')#('FFFFFF')

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 25) do
                pdf.stroke_bounds
                pdf.fill_color 'FFFFFF'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 25
                pdf.fill
                pdf.move_down mv

                pdf.text invoice.due_on, size: 10, align: :center, :color => ('000000'), overflow: :shrink_to_fit

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 20) do
                pdf.stroke_bounds
                pdf.fill_color 'C0C0C0'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 20
                pdf.fill
                pdf.move_down mv - md

                pdf.text "Order #", size: 10, align: :center, style: :bold, :color => ('000000')#('FFFFFF')

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 25) do
                pdf.stroke_bounds
                pdf.fill_color 'FFFFFF'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 25
                pdf.fill
                pdf.move_down mv

                pdf.text invoice.sales_order_number.to_s, size: 10, align: :center, :color => ('000000')

              end
            end # ENDS THE GRID BOUNDING BOX ON LINE 114

            pdf.grid(0,2).bounding_box do
              #pdf.stroke_bounds
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 20) do
                pdf.stroke_bounds
                pdf.fill_color 'C0C0C0'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 20
                pdf.fill
                pdf.move_down mv - md

                pdf.text "Amount Due", size: 10, align: :center, style: :bold, :color => ('000000')#('FFFFFF')

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 25) do
                pdf.stroke_bounds
                pdf.fill_color 'FFFFFF'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 25
                pdf.fill
                pdf.move_down mv

                pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.total), size: 10, align: :center, overflow: :shrink_to_fit, :color => ('000000')

              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 20) do
                pdf.stroke_bounds
                pdf.fill_color 'C0C0C0' #'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 20
                pdf.fill
                pdf.move_down mv - md

                pdf.text "PO #", size: 10, align: :center, style: :bold, :color => ('000000')#('FFFFFF') #Purchase Order #


              end
              pdf.bounding_box([0, pdf.cursor], :width => 72, :height => 25) do
                pdf.stroke_bounds
                pdf.fill_color 'FFFFFF'#'4d4dff'
                pdf.rectangle [0, pdf.cursor], 72, 25
                pdf.fill
                pdf.move_down mv

                pdf.text invoice.po_number, size: 10, align: :center, :color => ('000000'), overflow: :shrink_to_fit

              end
            end # ENDS THE GRID BOUNDING BOX ON LINE 124
        end # ENDS THE GRID BOUNDING BOX ON LINE 102

      end # STAMP FOR Gen_Info ON LINE 84
      pdf.stamp stamp_name
  end

  def item_header_first
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    #grid.show_all
    stamp_name = next_stamp("ItemHeader")
    pdf.create_stamp(stamp_name) do
      pdf.grid([5,0], [5,4]).bounding_box do
          #stroke_bounds
          pdf.move_down 15
          pdf.text "Item", style: :bold
          #pdf.text "Description"
          pdf.move_down 3
          pdf.stroke do
            pdf.line_width = 4
            pdf.stroke_color "000000"
            pdf.horizontal_line 0, 540, :at => pdf.cursor #y
            # self.line_width = 1
            # stroke_color "000000"
          end
      end
      pdf.grid(5,5).bounding_box do
          #stroke_bounds
          pdf.move_down 15
          pdf.text "QTY", align: :right, style: :bold
      end
      pdf.grid([5,6], [5,7]).bounding_box do
          #stroke_bounds
          pdf.move_down 15
          pdf.text "Price", align: :right, style: :bold

      end
      pdf.grid([5,8], [5,9]).bounding_box do
          #stroke_bounds
          pdf.move_down 15
          pdf.text "Total", align: :right, style: :bold
      end
    end
    pdf.stamp stamp_name
  end

  def item_header_next
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    #grid.show_all
    stamp_name = next_stamp("ItemHeader")
    pdf.create_stamp(stamp_name) do
      pdf.grid([3,0], [3,4]).bounding_box do
          #stroke_bounds
          pdf.move_down 5
          pdf.text "Item", style: :bold
          #pdf.text "Description"
          pdf.stroke do
            pdf.line_width = 4
            pdf.stroke_color "000000"
            pdf.horizontal_line 0, 540, :at => pdf.cursor #y
            # self.line_width = 1
            # stroke_color "000000"
          end
      end
      pdf.grid(3,5).bounding_box do
          #stroke_bounds
          pdf.move_down 5
          pdf.text "QTY", align: :right, size: 14, style: :bold
      end
      pdf.grid([3,6], [3,7]).bounding_box do
          #stroke_bounds
          pdf.move_down 5
          pdf.text "Price", align: :right, size: 14, style: :bold

      end
      pdf.grid([3,8], [3,9]).bounding_box do
          #stroke_bounds
          pdf.move_down 5
          pdf.text "Total", align: :right, size: 14, style: :bold
      end
    end
    pdf.stamp stamp_name
  end

  def footer
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    stamp_name = next_stamp("Footer")
    pdf.create_stamp(stamp_name) do
      pdf.grid([14,0],[15,2]).bounding_box do
        #pdf.stroke_bounds
        if 1== 1 #tenant.show_terms == true
          pdf.define_grid(columns: 2, rows: 1, gutter: 0)

          pdf.grid(0, 0).bounding_box do
            # transparent(0.05) { stroke_bounds }
            pdf.text 'Payment Terms', style: :bold, overflow: :shrink_to_fit, size: 10
            pdf.text 'Account Balance', style: :bold, overflow: :shrink_to_fit, size: 10
            # pdf.text 'Current', style: :bold, overflow: :shrink_to_fit, size: 10
            # pdf.text '31-60', style: :bold, overflow: :shrink_to_fit, size: 10
            # pdf.text '61-90', style: :bold, overflow: :shrink_to_fit, size: 10
            # pdf.text '91-120', style: :bold, overflow: :shrink_to_fit, size: 10
            #pdf.text 'Total Due', style: :bold, overflow: :shrink_to_fit, size: 10
          end

          pdf.grid(0, 1).bounding_box do
            pdf.text "Net 30", overflow: :shrink_to_fit, align: :right, size: 10
            pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.shipping), overflow: :shrink_to_fit, align: :right, size: 10
            # pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.tax), overflow: :shrink_to_fit, align: :right, size: 10
            # pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.discount), overflow: :shrink_to_fit, align: :right, size: 10
            # pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.total), overflow: :shrink_to_fit, align: :right, size: 10
            # pdf.text ActiveSupport::NumberHelper::number_to_currency(0), overflow: :shrink_to_fit, align: :right, size: 10
            #pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.balance), style: :bold, overflow: :shrink_to_fit, align: :right, size: 10
          end
        end

      end
      pdf.define_grid(columns: 10, rows: 16, gutter: 0)
      pdf.grid([14,3],[15,6]).bounding_box do
        #pdf.stroke_bounds

        pdf.text_box invoice.byline, size: 10, align: :center, style: :bold
      end
      pdf.grid([14,7],[15,9]).bounding_box do
        #stroke_bounds
        pdf.define_grid(columns: 2, rows: 1, gutter: 10)
        pdf.grid(0, 0).bounding_box do
          # transparent(0.05) { stroke_bounds }
          pdf.text 'Subtotal', style: :bold, overflow: :shrink_to_fit, size: 10
          pdf.text 'Shipping', style: :bold, overflow: :shrink_to_fit, size: 10
          pdf.text 'Tax', style: :bold, overflow: :shrink_to_fit, size: 10
          pdf.text 'Discount', style: :bold, overflow: :shrink_to_fit, size: 10
          pdf.text 'Total', style: :bold, overflow: :shrink_to_fit, size: 10
          pdf.text 'Payments', style: :bold, overflow: :shrink_to_fit, size: 10
          pdf.text 'Total Due', style: :bold, overflow: :shrink_to_fit, size: 10
        end

        pdf.grid(0, 1).bounding_box do
          pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.subtotal), overflow: :shrink_to_fit, align: :right, size: 10
          pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.shipping), overflow: :shrink_to_fit, align: :right, size: 10
          pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.tax), overflow: :shrink_to_fit, align: :right, size: 10
          pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.discount), overflow: :shrink_to_fit, align: :right, size: 10
          pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.total), style: :bold, overflow: :shrink_to_fit, align: :right, size: 10
          pdf.text ActiveSupport::NumberHelper::number_to_currency(0), overflow: :shrink_to_fit, align: :right, size: 10
          pdf.text ActiveSupport::NumberHelper::number_to_currency(invoice.balance), style: :bold, overflow: :shrink_to_fit, align: :right, size: 10
        end
      end
    end
    pdf.stamp stamp_name
  end

  def put_items
    x = []
    first_page_items = invoice.items.first(14)
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    pdf.grid([6,0], [13,4]).bounding_box do
      #pdf.stroke_bounds
      first_page_items.each_with_index do |item| #|item, index|
        x << pdf.cursor
        #puts x
        pdf.text "#{item.id} - #{item.title} ", overflow: :shrink_to_fit, size: 10 #{cursor}

        pdf.text item.description, overflow: :shrink_to_fit, size: 8
        pdf.stroke do
          pdf.line_width = 1
          pdf.stroke_color 'C0C0C0'
          pdf.horizontal_line 0, 540, :at => pdf.cursor #y
        end
        pdf.move_down 4
      end
    end

    pdf.grid([6,5], [13,5]).bounding_box do
      #puts x
      index = 0
      #stroke_bounds
      first_page_items.each_with_index do |item| #|item, index|
        pdf.move_cursor_to x[index]
        pdf.text ActiveSupport::NumberHelper::number_to_delimited(item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
        index += 1
      end
    end
    pdf.grid([6,6], [13,7]).bounding_box do
      index = 0
      #stroke_bounds
      first_page_items.each_with_index do |item| #|item, index|
        pdf.move_cursor_to x[index]
        pdf.text ActiveSupport::NumberHelper::number_to_currency(item.price), overflow: :shrink_to_fit, align: :right, size: 10
        index += 1
      end
    end
    pdf.grid([6,8], [13,9]).bounding_box do
      index = 0
      #stroke_bounds
      first_page_items.each_with_index do |item| #|item, index|
        pdf.move_cursor_to x[index]
        pdf.text ActiveSupport::NumberHelper::number_to_currency(item.price*item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
        index += 1
      end
    end
  end # end of page item function

  def put_items_next
    x = []
    first_page_items = invoice.items.first(14)
    #\
    # invoice.items[(14..invoice.items.length - 1)].in_groups_of(14) do |group|
    #   group.each do |item|
    #
    #   end
    # end
    invoice.items.select { |item| !first_page_items.map(&:id).include? item.id }.each_slice(19) do |batch|
      pdf.start_new_page
      pdf.define_grid(columns: 10, rows: 16, gutter: 0)

      header
      item_header_next
      x = []
      pdf.grid([4,0], [14,4]).bounding_box do
        #pdf.stroke_bounds
        batch.each_with_index do |item| #|item, index|
          x << pdf.cursor
          #puts x
          pdf.text "#{item.id} - #{item.title} ", overflow: :shrink_to_fit, size: 10 #{cursor}

          pdf.text item.description, overflow: :shrink_to_fit, size: 8
          pdf.stroke do
            pdf.line_width = 1
            pdf.stroke_color 250, 0, 0, 1
            pdf.horizontal_line 0, 540, :at => pdf.cursor #y
          end
          pdf.move_down 4
        end
      end

      pdf.grid([4,5], [14,5]).bounding_box do
        #puts x
        index = 0
        #stroke_bounds
        batch.each_with_index do |item| #|item, index|
          pdf.move_cursor_to x[index]
          pdf.text ActiveSupport::NumberHelper::number_to_delimited(item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
          index += 1
        end
      end
      pdf.grid([4,6], [14,7]).bounding_box do
        index = 0
        #stroke_bounds
        batch.each_with_index do |item| #|item, index|
          pdf.move_cursor_to x[index]
          pdf.text ActiveSupport::NumberHelper::number_to_currency(item.price), overflow: :shrink_to_fit, align: :right, size: 10
          index += 1
        end
      end
      pdf.grid([4,8], [14,9]).bounding_box do
        index = 0
        #stroke_bounds
        batch.each_with_index do |item| #|item, index|
          pdf.move_cursor_to x[index]
          pdf.text ActiveSupport::NumberHelper::number_to_currency(item.price*item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
          index += 1
        end
      end
      if batch.count < 17
        footer
        @addfoot = true
      end
    end
    if @addfoot == false
      pdf.start_new_page
      footer
    end
  end # end of page item function

  def page_number
    pdf.define_grid(columns: 10, rows: 16, gutter: 0)
    pdf.grid([15,4],[15,5]).bounding_box do
      # pdf.stroke_bounds
      #pdf.stroke_axis
      page_string = '<page> of <total>'
      options = {
        at: [0,0],
        #width: 150,
        align: :center
      }
      pdf.number_pages page_string, options
    end
  end

  def next_stamp(prefix)
    @stamp_count += 1
    "#{prefix}_#{@stamp_count}"
  end
end
