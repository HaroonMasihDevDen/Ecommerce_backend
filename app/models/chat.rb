class Chat < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :admin_user, optional: true

  after_update :broadcast_update

  def broadcast_update
    ActionCable.server.broadcast(
      "product_chat_#{product.id}",
      {
        answer: answer, 
        user_name: user.name, 
        created_at: created_at,
        updated_at: updated_at,
        id: id,
        action: 'update'
      }
    )
    puts "broadcasted update for chat id: #{id}"
  end

  validates :question, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["admin_user_id", "answer", "created_at", "id", "product_id", "question", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["admin_user", "product", "user"]
  end
end
