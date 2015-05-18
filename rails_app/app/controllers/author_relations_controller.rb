class AuthorRelationsController < DashboardController
  before_action :set_author_relation, only: [:show, :edit, :update, :destroy]

  # GET /author_relations
  # GET /author_relations.json
  def index
    @author_relations = AuthorRelation.all
  end

  # GET /author_relations/1
  # GET /author_relations/1.json
  def show
  end

  # GET /author_relations/new
  def new
    @author_relation = AuthorRelation.new
  end

  # GET /author_relations/1/edit
  def edit
  end

  # POST /author_relations
  # POST /author_relations.json
  def create
    @author_relation = AuthorRelation.new(author_relation_params)

    respond_to do |format|
      if @author_relation.save
        format.html { redirect_to @author_relation, notice: 'Author relation was successfully created.' }
        format.json { render :show, status: :created, location: @author_relation }
      else
        format.html { render :new }
        format.json { render json: @author_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /author_relations/1
  # PATCH/PUT /author_relations/1.json
  def update
    respond_to do |format|
      if @author_relation.update(author_relation_params)
        format.html { redirect_to @author_relation, notice: 'Author relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @author_relation }
      else
        format.html { render :edit }
        format.json { render json: @author_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /author_relations/1
  # DELETE /author_relations/1.json
  def destroy
    @author_relation.destroy
    respond_to do |format|
      format.html { redirect_to author_relations_url, notice: 'Author relation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author_relation
      @author_relation = AuthorRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_relation_params
      params.require(:author_relation).permit(:author_a_id, :author_b_id, :weight)
    end
end
