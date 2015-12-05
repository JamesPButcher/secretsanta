class Person < ActiveRecord::Base
  has_one :giving_to, class_name: 'Person', foreign_key: 'receiving_from_id'
  has_one :receiving_from, class_name: 'Person', foreign_key: 'giving_to_id'
  belongs_to :avoiding_giving_to, :class_name => 'Person', :foreign_key => 'avoiding_giving_to_id'

  validates :name, :email, :wishlist, presence: true
  validates :email_confirmation, presence: true, on: :create
  validate :email_matches_confirmation, on: :create
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  attr_accessor :email_confirmation

  def to_s
    Digest::MD5.hexdigest(name).truncate(16)
  end

  def self.people_who_havent_given
    where(giving_to_id: nil)
  end

  def self.people_who_have_not_received(excluded_ids:)
    where(receiving_from_id: nil).where.not(id: excluded_ids.flatten)
  end

  def give_to(recipient)
    return if self.id == recipient.id

    Person.transaction do
      self.giving_to = recipient
      recipient.receiving_from = self

      save!
      recipient.save!
    end
  end

  def avoid_giving_to(avoided_recipient)
    return if self.id == avoided_recipient.id

    Person.transaction do
      self.avoiding_giving_to = avoided_recipient
      save!
    end
  end

  def self.reset_gives
    Person.all.update_all(giving_to_id: nil, receiving_from_id: nil)
  end

  def self.all_giving_and_receiving?
    Person.where('giving_to_id IS NULL OR receiving_from_id IS NULL').count == 0
  end

  private

  def email_matches_confirmation
    if self.email != self.email_confirmation
      self.errors.add(:email_confirmation, 'does not match email.')
    end
  end
end
