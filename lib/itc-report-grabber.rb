require 'rubygems'
require 'mechanize'

class ItcReportGrabber
  attr_accessor :account_name, :account_pwd, :agent
  
  def initialize(account_name, account_pwd)
    @account_name = account_name
    @account_pwd = account_pwd
    @agent = Mechanize.new
  end
  
  def login
    #first we need to login to iTune Connect 
    page = @agent.get('http://itunesconnect.apple.com')
    login_form = page.forms.first
    login_form.theAccountName = @account_name
    login_form.theAccountPW = @account_pwd
    login_form.theAuxValue = ""
    page = @agent.submit(login_form)
    # if we can still get to the login form then it looks like we didn't get logged in...
    if page.forms.first["theAccountName"]
      raise StandardError, "Could not login to iTunes Connect, are your details correct?"
    end
  end
  
  def get_report(path, date = nil)
    login
    # if the login details were correct we should now be logged in
    page = @agent.get('https://itts.apple.com/cgi-bin/WebObjects/Piano.woa')
    # TODO - check if the login actually worked rather than assuming it did.
    download_form = page.forms[1]
    # type
    download_form["17.9"] = "Summary" 
    download_form["17.11"] = "Daily" 
    download_form["hiddenSubmitTypeName"] = "ShowDropDown"
    # we need to submit what we have so far, this will load the form with the 
    page = @agent.submit(download_form)
    download_form = page.forms[1]
    download_form["17.9"] = "Summary" 
    download_form["17.11"] = "Daily"
    if date 
      download_form["17.13.1"] = date
    end
    #"17.13.1" is the name of the select box with the available dates
    download_form["hiddenDayOrWeekSelection"] = download_form["17.13.1"]
    download_form["hiddenSubmitTypeName"] = "Download"
    download_form["download"] = "Download"

    file_name = download_form["hiddenDayOrWeekSelection"].gsub("/", "-") + ".txt"
    if !File.exists?(File.join(path, file_name))
      @agent.submit(download_form).save(File.join(path, file_name))
      puts file_name + " downloaded"
    else
      puts file_name + " already exists, not saving"
      file_name = ""
    end
    file_name
  end
  
  def get_latest_report(path)
    get_report path
  end
end