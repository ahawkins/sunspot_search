class CustomerObserver < ActiveRecord::Observer
  def after_save(customer)
    Customer.solr_reindex :batch_commit => false, :batch_size => nil
  end
end
