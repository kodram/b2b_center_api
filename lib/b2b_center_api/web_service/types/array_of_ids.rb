module B2bCenterApi
  module WebService
    module Types
      # Массив ID или других строк
      class ArrayOfIds < WebService::BaseType
        # @return [String[]]
        def self.from_part_response(response)
          return [] if response.nil?
          to_array(response).map { |n| convert(n[:string], :string) }
        end

        def self.from_response(response)
          r = response.result
          return if r.nil?
          Array(r[:ids])
        end
      end
    end
  end
end
