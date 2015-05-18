class TermRelationsController < DashboardController
  before_action :set_term_relation, only: [:show, :edit, :update, :destroy]

  # GET /term_relations
  # GET /term_relations.json
  def index
    @term_relations = TermRelation.all
  end

  # GET /term_relations/1
  # GET /term_relations/1.json
  def show
  end

  # GET /term_relations/new
  def new
    @term_relation = TermRelation.new
  end

  # GET /term_relations/1/edit
  def edit
  end

  # POST /term_relations
  # POST /term_relations.json
  def create
    @term_relation = TermRelation.new(term_relation_params)

    respond_to do |format|
      if @term_relation.save
        format.html { redirect_to @term_relation, notice: 'Term relation was successfully created.' }
        format.json { render :show, status: :created, location: @term_relation }
      else
        format.html { render :new }
        format.json { render json: @term_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /term_relations/1
  # PATCH/PUT /term_relations/1.json
  def update
    respond_to do |format|
      if @term_relation.update(term_relation_params)
        format.html { redirect_to @term_relation, notice: 'Term relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @term_relation }
      else
        format.html { render :edit }
        format.json { render json: @term_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /term_relations/1
  # DELETE /term_relations/1.json
  def destroy
    @term_relation.destroy
    respond_to do |format|
      format.html { redirect_to term_relations_url, notice: 'Term relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term_relation
      @term_relation = TermRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def term_relation_params
      params.require(:term_relation).permit(:term_a_id, :term_b_id, :weight)
    end
end
