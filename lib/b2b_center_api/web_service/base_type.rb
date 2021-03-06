require 'b2b_center_api/web_service/type_cast'
require 'b2b_center_api/remote_auction'
require 'b2b_center_api/remote_market'
require 'b2b_center_api/remote_tender'
require 'date'
require 'time'

module B2bCenterApi
  module WebService
    class BaseType
      include B2bCenterApi::WebService::TypeCast

      attr_writer :soap_client

      attr_reader :date_fields

      NO_INSPECT_ATTRS = [:@soap_client]

      def inspect
        vars = instance_variables
        NO_INSPECT_ATTRS.each { |a| vars.delete(a) }
        vars = vars.map { |v| "#{v}=#{instance_variable_get(v).inspect}" }
        vars = vars.join(', ')
        "<#{self.class}: #{vars}>"
      end

      def to_h
        hash = {}
        vars = instance_variables
        NO_INSPECT_ATTRS.each { |a| vars.delete(a) }

        vars.each { |var| hash[var.to_s.delete('@').to_sym] = instance_variable_get(var) }

        date_fields.each { |d| hash[d] = parse_date(hash[d]) } if date_fields

        hash
      end

      private

      def remote_auction
        B2bCenterApi::RemoteAuction.new(@soap_client)
      end

      def remote_market
        B2bCenterApi::RemoteMarket.new(@soap_client)
      end

      def remote_tender
        B2bCenterApi::RemoteTender.new(@soap_client)
      end

      def parse_date(date)
        if date.is_a? Date
          return date.strftime("%d.%m.%Y")
        elsif date.is_a? Time
          return date.strftime('%d.%m.%Y %H:%M')
        end
        date
      end

      def self.to_array(obj)
        obj.is_a?(Hash) ? [obj] : obj
      end
    end
  end
end
