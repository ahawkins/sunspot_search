module SunspotSearch
  class Condition
    attr_accessor :attribute, :operator, :value
    attr_accessor :search, :choices, :type, :hint, :dynamic
    
    def self.human_name
      'condition'
    end

    def self.model_name
      human_name
    end

    def new_record?
      true
    end

    def initialize(attributes = {}, &block)
      attributes.each_pair do |name, value|
        send("#{name}=", value)
      end
    
      yield(self) if block_given?
    end
    
    def persisted?
      false
    end

    def form_configuration
      search.form_configuration
    end

    def valid?
      flag = attribute.present? && operator.present? && type.present?

      if operator && operator.to_sym != :blank && operator.to_sym != :not_blank 
        flag && value.present?
      else
        flag
      end
    end

    def attribute_value
      case type.to_sym
      when :currency, :float
        currency_attribute_value
      when :integer
        integer_attribute_value
      when :string
        value
      when :time
        time_attribute_value
      end
    end

    private
    def integer_attribute_value
      case operator.to_sym
      when :between
        parts = value.split('-')
        Range.new currency_to_number(parts[0].strip).to_i, currency_to_number(parts[1].strip).to_i
      else
        currency_to_number(value).to_i
      end
    end
    
    def time_attribute_value
      case operator.to_sym
      when :between
        parts = value.split('-')
        Range.new Time.parse(parts[0]), Time.parse(parts[1])
      when :equal
        time = Time.parse value
        time.at_beginning_of_day..time.end_of_day
      else
        Time.parse value
      end
    end

    def currency_attribute_value
      case operator.to_sym
      when :between
        parts = value.split('-')
        Range.new currency_to_number(parts[0].strip), currency_to_number(parts[1].strip)
      else
        currency_to_number(value)
      end
    end

    def currency_to_number(string)
      if string =~ /[,\.]\d\d?$/
        parts = string.match /(.+)[,\.](\d\d?)/
        whole = parts[1].gsub /\D/, ''
        "#{whole}.#{parts[2]}".to_f
      else
        string.gsub(/\D/,'').to_f
      end
    end
   end
end
