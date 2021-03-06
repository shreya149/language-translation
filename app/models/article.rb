# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  english     :text
#  phonetic    :text
#  created_at  :datetime
#  updated_at  :datetime
#  picture     :string
#  language_id :integer
#  tsv_data    :tsvector
#  category_id :integer
#  state       :string           default("draft")
#

class Article < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  belongs_to :language
  belongs_to :category
  has_many :audios, dependent: :delete_all

  accepts_nested_attributes_for :audios, allow_destroy: true, reject_if: lambda { |a| a['audio'].blank? }

  # default order when calling the Article model
  default_scope -> { order('created_at DESC') }
  default_value_for :state, 0

  # CarrierWave integration for uploading pictures
  mount_uploader :picture, PictureUploader

  validates_presence_of :picture
  validates_presence_of :phonetic

  validates_presence_of :category_id

  enum state:   [:draft, :published]
  
  filterrific(
    available_filters: [
      :with_language_id,
      :with_category_id,
    ]
  )
  
  belongs_to :language
  scope :with_language_id, lambda { |language_ids|
    where(:language_id => [*language_ids])
  }
  
  belongs_to :category
  scope :with_category_id, lambda { |category_ids|
    where(:category_id => [*category_ids])
  }

  delegate :name, :to => :language, :prefix => true
 end