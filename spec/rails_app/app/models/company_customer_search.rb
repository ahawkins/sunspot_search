# this class is here to test the 'searchs' method
# to set the class on classes that have complicated
# or different names than 'ClassSearch'

class CompanyCustomerSearch < SunspotSearch::Search
  searches Customer
end
