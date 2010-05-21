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
      String :Provider
      String :ProviderCountry
      String :VendorIdentifier
      String :UPC
      String :ISRC
      String :ArtistShow
      String :TitleEpisodeSeason
      String :LabelStudioNetwork
      String :ProductTypeIdentifier
      Fixnum :Units
      Numeric :RoyaltyPrice
      Date :BeginDate
      Date :EndDate
      String :CustomerCurrency
      String :CountryCode
      Numeric :RoyaltyCurrency
      String :Preorder
      String :SeasonPass
      String :ISAN
      String :AppleIdentifier
      Numeric :CustomerPrice
      String :CMA
      String :AssetContentFlavor
      String :VendorOfferCode
      String :Grid
      String :PromoCode
      String :ParentIdentifier
    end
  end
  
  def save_report(report_hash)
    dataset = @DB[:itc_daily_reports]
    dataset.multi_insert(report_hash)
  end
end