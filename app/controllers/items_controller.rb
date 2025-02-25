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
    # the_item.photo = params.fetch("query_photo")
    the_item.comment = params.fetch("query_comment")

    # require "http"

    # Prepare a hash that will become the headers of the request
    request_headers_hash = {
      "Authorization" => "Bearer #{ENV.fetch("OPENAI_API_KEY")}",
      "content-type" => "application/json"
    }

    # Prepare a hash that will become the body of the request
    request_body_hash = {
      "model" => "gpt-4o",
      "messages" => [
        {
          "role" => "system",
          "content" => "You are an expert nutritionist. The user will describe a meal. You should estimate the grams of protein, grams of carbohydrates, grams of fat, and total calories."
        },
        {
          "role" => "user",
          "content" => the_item.comment
        }
      ]
    }

    # Convert the Hash into a String containing JSON
    request_body_json = JSON.generate(request_body_hash)

    # Make the API call
    raw_response = HTTP.headers(request_headers_hash).post(
      "https://api.openai.com/v1/chat/completions",
      :body => request_body_json
    ).to_s

    # Parse the response JSON into a Ruby Hash
    @parsed_response = JSON.parse(raw_response)

    render({:template => "items/preview"})



    # the_item.calories = params.fetch("query_calories")
    # the_item.carbs = params.fetch("query_carbs")
    # the_item.protein = params.fetch("query_protein")
    # the_item.fat = params.fetch("query_fat")

    # if the_item.valid?
    #   the_item.save
    #   redirect_to("/items", { :notice => "Item created successfully." })
    # else
    #   redirect_to("/items", { :alert => the_item.errors.full_messages.to_sentence })
    # end
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
