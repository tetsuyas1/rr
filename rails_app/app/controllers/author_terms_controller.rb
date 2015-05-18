class AuthorTermsController < DashboardController
  before_action :set_author_term, only: [:show, :edit, :update, :destroy]

  # GET /author_terms
  # GET /author_terms.json
  def index
    @author_terms = AuthorTerm.all
  end

  # GET /author_terms/1
  # GET /author_terms/1.json
  def show
  end

  # GET /author_terms/new
  def new
    @author_term = AuthorTerm.new
  end

  # GET /author_terms/1/edit
  def edit
  end

  # POST /author_terms
  # POST /author_terms.json
  def create
    @author_term = AuthorTerm.new(author_term_params)

    respond_to do |format|
      if @author_term.save
        format.html { redirect_to @author_term, notice: 'Author term was successfully created.' }
        format.json { render :show, status: :created, location: @author_term }
      else
        format.html { render :new }
        format.json { render json: @author_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /author_terms/1
  # PATCH/PUT /author_terms/1.json
  def update
    respond_to do |format|
      if @author_term.update(author_term_params)
        format.html { redirect_to @author_term, notice: 'Author term was successfully updated.' }
        format.json { render :show, status: :ok, location: @author_term }
      else
        format.html { render :edit }
        format.json { render json: @author_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /author_terms/1
  # DELETE /author_terms/1.json
  def destroy
    @author_term.destroy
    respond_to do |format|
      format.html { redirect_to author_terms_url, notice: 'Author term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author_term
      @author_term = AuthorTerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_term_params
      params.require(:author_term).permit(:author_id, :term_id, :weight)
    end
end
