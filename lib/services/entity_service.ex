defmodule Services.EntityService do

  alias Repository.EntityRepository
  alias Services.IndexService
  require Logger
  
  

  def add_entity(%{"title" =>  _title, "type" => _type} = data) do
    inserted = EntityRepository.add(data)
    IndexService.init(data, inserted)
    {:ok, "This entity has added successfully"}
  end

  def add_entity(_), do: {:malformed_data, "Cannot add this entity: please enter the correct values"}
  
  def get_entity(query) do 
    references = IndexService.get_references(query) 
    entities = references 
               |> Enum.map(fn ref -> EntityRepository.get(ref)end)
               |> Enum.map(fn entity -> Map.update!(entity, "_id", fn id -> BSON.ObjectId.encode!(id) end) end)
    entities
  end
end 
