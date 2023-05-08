module Recurly3
  class Item < Resource
    # @return [[CustomField], []]
    has_many :custom_fields, class_name: :CustomField, readonly: false

    define_attribute_methods %w(
      item_code
      name
      description
      external_sku
      accounting_code
      revenue_schedule_type
      state
      created_at
      updated_at
      deleted_at
    )

    def changed_attributes
      attrs = super
      if custom_fields.any?(&:changed?)
        attrs['custom_fields'] = custom_fields.select(&:changed?)
      end
      attrs
    end

    def reactivate
      return false unless link? :reactivate
      reload follow_link :reactivate
      true
    end

  end
end
