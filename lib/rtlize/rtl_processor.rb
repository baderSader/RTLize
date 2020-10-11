module Rtlize
  class RtlProcessor
    require 'sprockets/processing'
    extend Sprockets::Processing

    def initialize(filename, &block)
      @filename = filename
      @source   = block.call
    end

    def render(context, _options)
      self.class.run(@filename, @source, context)
    end

    def self.run(filename, source, context)
      allowed_extensions = ['sass', 'css', 'scss']
      extension = context.pathname.basename.to_s.split('.').length > 1 ? context.pathname.basename.to_s.split('.')[-1] : nil
      if extension && allowed_extensions.include?(extension) && context.pathname.basename.to_s.match(/\.rtl/i)
        Rtlize::RTLizer.transform(source)
      else
        source
      end
    end

    def self.call(input)
      filename = input[:filename]
      source   = input[:data]
      context  = input[:environment].context_class.new(input)

      result = run(filename, source, context)
      context.metadata.merge(data: result)
    end
  end
end
