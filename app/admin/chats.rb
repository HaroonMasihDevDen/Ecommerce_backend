ActiveAdmin.register Chat, as: 'Product-Queries' do

  # actions :all, except: [:new, :create]

  # Permit params for form submission
  permit_params :product_id, :user_id, :admin_user_id, :question, :answer

  # Filters
  filter :product
  filter :user
  filter :admin_user, as: :select, collection: AdminUser.all.map { |u| [u.email, u.id] }
  filter :question
  filter :answer
  filter :created_at
  filter :updated_at

  # Index page
  index do
    selectable_column
    id_column
    column :product
    column :user
    column :admin_user
    column :question do |chat|
      truncate(chat.question, length: 50)
    end
    column :answer do |chat|
      truncate(chat.answer, length: 50) if chat.answer.present?
    end
    column :created_at
    column :updated_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :product
      row :user
      row :admin_user
      row :question
      row :answer
      row :created_at
      row :updated_at
    end
  end

  # Form
  form do |f|
    f.semantic_errors
    f.inputs "Product query from user #{f.object.user.email} || #{f.object.user.name} || #{f.object.product.name} || product_id: #{f.object.product.id} || #{f.object.question}" do
      f.input :answer
    end
    f.actions
  end

  # Scopes
  scope :all, default: true
  scope :answered do |chats|
    chats.where.not(answer: nil)
  end
  scope :unanswered do |chats|
    chats.where(answer: nil)
  end

  # Custom action for quick response
  member_action :quick_answer, method: :put do
    resource.update(answer: params[:answer], admin_user: current_admin_user)
    redirect_to resource_path, notice: 'Answer updated successfully'
  end

  # Batch actions
  batch_action :assign_to_admin, form: -> {
    { admin_user: AdminUser.pluck(:email, :id) }
  } do |ids, inputs|
    batch_action_collection.find(ids).each do |chat|
      chat.update(admin_user_id: inputs[:admin_user])
    end
    redirect_to collection_path, notice: 'Chats have been assigned'
  end

  # Customize the CSV download
  csv do
    column :id
    column(:product) { |chat| chat.product.name }
    column(:user) { |chat| chat.user.email }
    column(:admin_user) { |chat| chat.admin_user&.email }
    column :question
    column :answer
    column :created_at
    column :updated_at
  end

  # Sidebar for stats
  sidebar 'Chat Statistics', only: :index do
    ul do
      li "Total Chats: #{Chat.count}"
      li "Answered: #{Chat.where.not(answer: nil).count}"
      li "Unanswered: #{Chat.where(answer: nil).count}"
    end
  end

  # Controller customization
  controller do
    def scoped_collection
      super.includes(:product, :user, :admin_user)
    end

    def create
      params[:chat][:admin_user_id] = current_admin_user.id
      super
    end
  end
end