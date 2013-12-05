module Spira::Types

  ##
  # A {Spira::Type} for dates.  Values will be associated with the
  # `XSD.date` type.
  #
  # A {Spira::Resource} property can reference this type as
  # `Spira::Types::Date`, `Date`, or `XSD.date`.
  #
  # @see Spira::Type
  # @see http://rdf.rubyforge.org/RDF/Literal.html
  class Date
    include Spira::Type

    def self.unserialize(value)
      object = value.object
      object.to_date if object.respond_to?(:to_date)
    end

    def self.serialize(value)
      RDF::Literal.new(value.to_s, :datatype => XSD.date)
    end

    register_alias XSD.date

  end
end
