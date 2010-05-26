require 'rubygems'
require 'sequel'

class ItcReportPersister    
    
  def initialize(path)
    @DB = Sequel.sqlite(File.join(path, 'itc-reports.db'))
    create_report_table?
  end
  
  def create_report_table?
    @DB.create_table? String :itc_daily_reports do
      primary_key :id
      string :provider
      string :provider_country
      string :vendor_identifier
      string :upc
      string :isrc
      string :artist_show
      string :title_episode_season
      string :label_studio_network
      string :product_type_identifier
      fixnum :units
      numeric :royalty_price
      date :begin_date
      date :end_date
      string :customer_currency
      string :country_code
      numeric :royalty_currency
      string :preorder
      string :season_pass
      string :isan
      string :apple_identifier
      numeric :customer_price
      string :cma
      string :asset_content_flavor
      string :vendor_offer_code
      string :grid
      string :promo_code
      string :parent_identifier
    end
  end
  
  def save_report(report_hash)
    dataset = @DB[:itc_daily_reports]
    dataset.multi_insert(report_hash)
  end
end