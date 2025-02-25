class ItemsController < ApplicationController
  def index
    matching_items = Item.all

    @list_of_items = matching_items.order({ :created_at => :desc })

    render({ :template => "items/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_items = Item.where({ :id => the_id })

    @the_item = matching_items.at(0)

    render({ :template => "items/show" })
  end

  def create
    the_item = Item.new
    the_item.photo = params.fetch("query_photo")
    the_item.calories = params.fetch("query_calories")
    the_item.carbs = params.fetch("query_carbs")
    the_item.protein = params.fetch("query_protein")
    the_item.fat = params.fetch("query_fat")
    the_item.comment = params.fetch("query_comment")

    if the_item.valid?
      the_item.save
      redirect_to("/items", { :notice => "Item created successfully." })
    else
      redirect_to("/items", { :alert => the_item.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_item = Item.where({ :id => the_id }).at(0)

    the_item.photo = params.fetch("query_photo")
    the_item.calories = params.fetch("query_calories")
    the_item.carbs = params.fetch("query_carbs")
    the_item.protein = params.fetch("query_protein")
    the_item.fat = params.fetch("query_fat")
    the_item.comment = params.fetch("query_comment")

    if the_item.valid?
      the_item.save
      redirect_to("/items/#{the_item.id}", { :notice => "Item updated successfully."} )
    else
      redirect_to("/items/#{the_item.id}", { :alert => the_item.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_item = Item.where({ :id => the_id }).at(0)

    the_item.destroy

    redirect_to("/items", { :notice => "Item deleted successfully."} )
  end
end
