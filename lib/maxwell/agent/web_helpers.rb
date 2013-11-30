module Maxwell
  module Agent
    module WebHelpers
      def root_path
        env['SCRIPT_NAME']
      end
    end
  end
end
