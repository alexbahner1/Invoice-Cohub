require 'json'
require 'ostruct'
require 'prawn'
require 'active_support'
require 'open-uri'

data = {
  tenant: {
    company_name: 'TapeOnline',
    address: {
      'filled_in?' => true,
      full_street: '438 Houston St. Suite 288',
      city_state_zip: 'Nashville, TN 37203',
      phone_number: '877-296-3041'
    },
    logo: {
      medium_url: 'https://99percentinvisible.org/app/uploads/2017/03/nike-and-target-logos.jpg',
    }
  },
  invoice: {
    id: 2786,
    sales_order_number: 59246,
    invoice_date: Time.at(1515608769).strftime('%m/%d/%Y'),
    due_on: Time.at(1518200764).strftime('%m/%d/%Y'),
    po_number: 'PO1234',
    shipping_method: 'Pickup',
    payment_terms: '30 Days',
    properties: {},
    customer: {
      name: 'Ashley Hays',
      id: 1234
    },
    #customer_name: 'Alex Bahner',
    billing_address: {
      'filled_in?' => true,
      name: 'Dave Smith',
      full_street: '438 Houston St. Suite 288',
      city_state_zip: 'Nashville, TN 37203',
      phone_number: '877-296-3041'
    },
    shipping_address:{
        'filled_in?' => true,
        name: 'Alex Bahner',
        full_street: '438 Houston St. Suite 288',
        city_state_zip: 'Nashville, TN 37203',
        phone_number: '877-296-3041'
    },
    items: [
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      },
      {
        title: "Item #1",
        description: "Cool stuff",
        quantity: 4,
        price: 14.5
      }
    ],

  }
}


data = data.to_json
data = JSON.parse(data, object_class: OpenStruct)

tenant = data.tenant
invoice = data.invoice
customer_name = invoice.customer_name
tmp_path = Dir.pwd + '/invoice.pdf'
first_page_items = invoice.items.first(12)
#link = "https://99percentinvisible.org/app/uploads/2017/03/nike-and-target-logos.jpg"


Prawn::Document.generate(tmp_path, page_size: 'LETTER', page_layout: :portrait) do
  #image open(link), fit: [60, 38]
  font_families.update(
    'Lato' => {
      normal: { file: "#{Dir.pwd}/fonts/Lato-Regular.ttf", font: 'Lato-Regular' },
      bold: { file: "#{Dir.pwd}/fonts/Lato-Bold.ttf", font: 'Lato-Bold' }
    }
  )

  font 'Lato'

  create_stamp('header') do
    define_grid(columns: 3, rows: 8, gutter: 10)

    grid(0, 0).bounding_box do
      define_grid(columns: 1, rows: 2, gutter: 2)
      grid(0, 0).bounding_box do
        if tenant.logo
          begin
            image open(tenant.logo.medium_url), fit: [100, 60]
          rescue StandardError # If the image cannot be loaded, show the name (Prawn will exception when unable to load)
            text tenant.company_name, size: 16, style: :bold
          end
        else
          text tenant.company_name, size: 16, style: :bold
        end
      end

      grid(1, 0).bounding_box do
        if tenant.address && tenant.address.filled_in?
          text tenant.address.full_street, overflow: :shrink_to_fit
          text tenant.address.city_state_zip, overflow: :shrink_to_fit
          text tenant.address.phone_number, overflow: :shrink_to_fit
        end
      end
    end

    define_grid(columns: 3, rows: 8, gutter: 10)

    grid(0, 1).bounding_box do
      text 'INVOICE', align: :center, size: 18, style: :bold
    end

    grid(0, 2).bounding_box do
      # transparent(0.05) { stroke_bounds }
      define_grid(columns: 2, rows: 1, gutter: 10)
      grid(0, 0).bounding_box do
        bounding_box([0, cursor], :width => 92, :height => 15) do
          move_down 2
          indent(3) do
            text 'Invoice', style: :bold
          end
          stroke_bounds
        end
        #text 'Account', style: :bold
        bounding_box([0, cursor], :width => 92, :height => 15) do
          move_down 2
          indent(3) do
            text 'Date', style: :bold
          end
          stroke_bounds
        end
        bounding_box([0, cursor], :width => 92, :height => 15) do
          move_down 2
          indent(3) do
            text 'Due On', style: :bold
          end
          stroke_bounds
        end
        bounding_box([0, cursor], :width => 92, :height => 15) do
          move_down 2
          indent(3) do
            text 'Page', style: :bold
          end
          stroke_bounds
        end
      end

      grid(0, 1).bounding_box do
        bounding_box([0, cursor], :width => 100, :height => 15) do
          move_down 2
          text invoice.id.to_s, align: :center
          stroke_bounds
        end
        #text invoice.customer_id.to_s, align: :right
        bounding_box([0, cursor], :width => 100, :height => 15) do
          move_down 2
          text invoice.invoice_date, align: :center
          stroke_bounds
        end
        bounding_box([0, cursor], :width => 100, :height => 15) do
          move_down 2
          text invoice.due_on, align: :center
          stroke_bounds
        end
      end
    end
  end

  create_stamp('addresses') do
    define_grid(columns: 5, rows: 8, gutter: 10)

    grid([1, 0], [1, 1]).bounding_box do
      text 'Bill To:', style: :bold

      address = invoice.billing_address
      if address && address.filled_in?
        bounding_box([0, cursor], :width => 180, :height => 64) do
        # transparent(0.05) { stroke_bounds }
          move_down 5
          indent(5) do
            text address.name, overflow: :shrink_to_fit
            text address.full_street, overflow: :shrink_to_fit
            text address.city_state_zip, overflow: :shrink_to_fit
            text address.phone_number, overflow: :shrink_to_fit
          end
          stroke_bounds
        end
      end
    end

    grid([1, 3], [1, 4]).bounding_box do
      text 'Ship To:', style: :bold

      address = invoice.shipping_address
      if address && address.filled_in?
        bounding_box([0, cursor], :width => 180, :height => 64) do
        # transparent(0.05) { stroke_bounds }
          move_down 5
          indent(5) do
            text address.name, overflow: :shrink_to_fit
            text address.full_street, overflow: :shrink_to_fit
            text address.city_state_zip, overflow: :shrink_to_fit
            text address.phone_number, overflow: :shrink_to_fit
          end
          stroke_bounds
        end
      end
    end
  end

  create_stamp('meta') do
    # Meta
    define_grid(columns: 4, rows: 8, gutter: 10)
    #bounding_box([0, cursor], :width => 300, :height => 80) do
      grid(2, 0).bounding_box do
        text 'Purchase Order #', style: :bold
        text invoice.po_number
      end
      grid(2, 1).bounding_box do
        text 'Shipping Method', style: :bold
        text invoice.shipping_method
      end
      grid(2, 2).bounding_box do
        text 'Customer', style: :bold
        text invoice.customer.name
      end
      grid(2, 3).bounding_box do
        text 'Payment Terms', style: :bold
        text '30 Days'
      end

  end

  stroke do
    self.line_width = 15
    stroke_color 50, 100, 0, 0
    horizontal_line 0, 540, :at => y
  end

  stamp 'addresses'

  stamp 'meta'

  create_stamp 'properties' do
    define_grid(columns: 3, rows: 8, gutter: 20)
    grid([7, 0], [7, 0]).bounding_box do
      # transparent(0.05) { stroke_bounds }
      define_grid(columns: 2, rows: 1, gutter: 10)
      grid(0, 0).bounding_box do
        # transparent(0.05) { stroke_bounds }
        invoice.properties.each_key do |key|
          text key, style: :bold, overflow: :shrink_to_fit, size: 10
        end
      end

      grid(0, 1).bounding_box do
        invoice.properties.each_value do |value|
          text value, overflow: :shrink_to_fit, align: :right, size: 10
        end
      end
    end
  end

  create_stamp 'totals' do
    define_grid(columns: 3, rows: 40, gutter: 30)
    grid([34, 2], [39, 2]).bounding_box do
      # transparent(0.05) { stroke_bounds }
      define_grid(columns: 2, rows: 1, gutter: 10)
      grid(0, 0).bounding_box do
        # transparent(0.05) { stroke_bounds }
        text 'Subtotal', style: :bold, overflow: :shrink_to_fit, size: 10
        text 'Shipping', style: :bold, overflow: :shrink_to_fit, size: 10
        text 'Tax', style: :bold, overflow: :shrink_to_fit, size: 10
        text 'Discount', style: :bold, overflow: :shrink_to_fit, size: 10
        text 'Total', style: :bold, overflow: :shrink_to_fit, size: 10
        text 'Payments', style: :bold, overflow: :shrink_to_fit, size: 10
        text 'Total Due', style: :bold, overflow: :shrink_to_fit, size: 10
      end

      grid(0, 1).bounding_box do
        text ActiveSupport::NumberHelper::number_to_currency(invoice.subtotal), overflow: :shrink_to_fit, align: :right, size: 10
        text ActiveSupport::NumberHelper::number_to_currency(invoice.shipping), overflow: :shrink_to_fit, align: :right, size: 10
        text ActiveSupport::NumberHelper::number_to_currency(invoice.tax), overflow: :shrink_to_fit, align: :right, size: 10
        text ActiveSupport::NumberHelper::number_to_currency(invoice.discount), overflow: :shrink_to_fit, align: :right, size: 10
        text ActiveSupport::NumberHelper::number_to_currency(invoice.total), overflow: :shrink_to_fit, align: :right, size: 10
        text ActiveSupport::NumberHelper::number_to_currency(0), overflow: :shrink_to_fit, align: :right, size: 10
        text ActiveSupport::NumberHelper::number_to_currency(invoice.balance), overflow: :shrink_to_fit, align: :right, size: 10
      end
    end
  end

  # First page of Items
  define_grid(columns: 1, rows: 8, gutter: 10)
  grid([3, 0], [7, 0]).bounding_box do
    define_grid(columns: 16, rows: 16, gutter: 10)
    grid([0, 0], [0, 9]).bounding_box do
      text 'Item', style: :bold
    end
    # grid([0, 4], [0, 9]).bounding_box do
    #   text 'Description', style: :bold
    # end
    grid([0, 10], [0, 11]).bounding_box do
      text 'Quantity', style: :bold, align: :right
    end
    grid([0, 12], [0, 13]).bounding_box do
      text 'Price', style: :bold, align: :right
    end
    grid([0, 14], [0, 15]).bounding_box do
      text 'Total', style: :bold, align: :right
    end

    first_page_items.each_with_index do |item, index|
      grid([index + 1, 0], [index + 1, 9]).bounding_box do
        text "#{item.id} - #{item.title}", overflow: :shrink_to_fit, size: 10
        text item.description, overflow: :shrink_to_fit, size: 8
      end

      # grid([index + 1, 4], [index + 1, 9]).bounding_box do
      #   text item.description, overflow: :shrink_to_fit
      # end

      grid([index + 1, 10], [index + 1, 11]).bounding_box do
        text ActiveSupport::NumberHelper::number_to_delimite+d(item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
      end

      grid([index + 1, 12], [index + 1, 13]).bounding_box do
        text ActiveSupport::NumberHelper::number_to_currency(item.price), overflow: :shrink_to_fit, align: :right, size: 10
      end

      grid([index + 1, 14], [index + 1, 15]).bounding_box do
        text ActiveSupport::NumberHelper::number_to_currency(item.line_total), overflow: :shrink_to_fit, align: :right, size: 10
      end

      stroke do
        self.line_width = 2
        stroke_color 50, 100, 0, 0
        horizontal_line 0, 540, :at => y - 38
      end
    end
  end

  if invoice.items.count < 13
    stamp 'properties'
    stamp 'totals'
  else
    # Subsequent Pages of items
    invoice.items.where.not(id: first_page_items.pluck(:id)).order(created_at: :asc).find_in_batches(batch_size: 12) do |batch|
    invoice.items[14..length]
      start_new_page
      define_grid(columns: 1, rows: 8, gutter: 10)
      grid([1, 0], [7, 0]).bounding_box do
        define_grid(columns: 16, rows: 15, gutter: 10)
        grid([0, 0], [0, 9]).bounding_box do
          text 'Item', style: :bold
        end
        # grid([0, 4], [0, 9]).bounding_box do
        #   text 'Description', style: :bold
        # end
        grid([0, 10], [0, 11]).bounding_box do
          text 'Quantity', style: :bold, align: :right
        end
        grid([0, 12], [0, 13]).bounding_box do
          text 'Price', style: :bold, align: :right
        end
        grid([0, 14], [0, 15]).bounding_box do
          text 'Total', style: :bold, align: :right
        end

        batch.each_with_index do |item, index|
          grid([index + 1, 0], [index + 1, 9]).bounding_box do
            text "#{item.id} - #{item.title}", overflow: :shrink_to_fit, size: 10
            text item.description, overflow: :shrink_to_fit, size: 8
          end

          # grid([index + 1, 4], [index + 1, 9]).bounding_box do
          #   text item.description, overflow: :shrink_to_fit
          # end

          grid([index + 1, 10], [index + 1, 11]).bounding_box do
            text ActiveSupport::NumberHelper::number_to_delimited(item.quantity), overflow: :shrink_to_fit, align: :right, size: 10
          end

          grid([index + 1, 12], [index + 1, 13]).bounding_box do
            text ActiveSupport::NumberHelper::number_to_currency(item.price), overflow: :shrink_to_fit, align: :right, size: 10
          end

          grid([index + 1, 14], [index + 1, 15]).bounding_box do
            text ActiveSupport::NumberHelper::number_to_currency(item.line_total), overflow: :shrink_to_fit, align: :right, size: 10
          end
        end

        if batch.count < 12
          stamp 'properties'
          stamp 'totals'
        end
      end
    end
  end

  # Header
  repeat(:all, dynamic: true) do
    stamp 'header'
  end

  # Page Numbers
  define_grid(columns: 3, rows: 8, gutter: 10)
  grid(0, 1).bounding_box do
    page_string = '<page> of <total>'
    options = {
      at: [bounds.right + 34, 35],
      width: 150,
      align: :right
    }
    number_pages page_string, options
  end
end
