class Bill < ApplicationRecord
    include ActiveModel::Model
    attr_accessor :code, :name, :ementa, :bill_text_link, :date, :authors, :status
end
