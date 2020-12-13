module Orders
  class CommentsService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors, :params

    def initialize(params)
      @params = params
      @errors = []
    end

    def json_view
      { comments: OrderComment
                      .where(order_id: params[:order_id])
                      .as_json(only: [:id, :comment, :created_at], include: { user_account: { only: :username}})}
    end

    def create_comment
      @comment = OrderComment.new(params)
      @comment.save
      @errors << fill_errors(@comment) if @comment.errors.any?
    end

    def list
    end
  end
end