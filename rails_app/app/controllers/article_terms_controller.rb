class ArticleTermsController < DashboardController
  before_action :set_article_term, only: [:show, :edit, :update, :destroy]

  # GET /article_terms
  # GET /article_terms.json
  def index
    @article_terms = ArticleTerm.all
  end

  # GET /article_terms/1
  # GET /article_terms/1.json
  def show
  end

  # GET /article_terms/new
  def new
    @article_term = ArticleTerm.new
  end

  # GET /article_terms/1/edit
  def edit
  end

  # POST /article_terms
  # POST /article_terms.json
  def create
    @article_term = ArticleTerm.new(article_term_params)

    respond_to do |format|
      if @article_term.save
        format.html { redirect_to @article_term, notice: 'Article term was successfully created.' }
        format.json { render :show, status: :created, location: @article_term }
      else
        format.html { render :new }
        format.json { render json: @article_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_terms/1
  # PATCH/PUT /article_terms/1.json
  def update
    respond_to do |format|
      if @article_term.update(article_term_params)
        format.html { redirect_to @article_term, notice: 'Article term was successfully updated.' }
        format.json { render :show, status: :ok, location: @article_term }
      else
        format.html { render :edit }
        format.json { render json: @article_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_terms/1
  # DELETE /article_terms/1.json
  def destroy
    @article_term.destroy
    respond_to do |format|
      format.html { redirect_to article_terms_url, notice: 'Article term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_term
      @article_term = ArticleTerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_term_params
      params.require(:article_term).permit(:article_id, :term_id)
    end
end
