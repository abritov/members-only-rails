class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new if user_signed_in?  # For the inline form on index page
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new(user_id: current_user.id) if user_signed_in?
    # Don't set @posts here - that's for index action only
  end

  # POST /posts or /posts.json
  def create
    if user_signed_in?
      @post = Post.new(post_params)
      @post.user_id = current_user.id

      respond_to do |format|
        if @post.save
          format.html { redirect_to posts_path, notice: "Post was successfully created." }
        else
          # When create fails, we need to render index with all posts
          @posts = Post.all.order(created_at: :desc)
          format.html { render :index, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_user_session_path, alert: "Please sign in to create posts."
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params.expect(:id))
  end

  def post_params
    params.expect(post: [ :user_id, :title, :body ])
  end
end
