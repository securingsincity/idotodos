defmodule IdotodosEx.WeddingSharedView do
  use IdotodosEx.Web, :view

  def registry_image(conn, name) do
    case name do
      "Honeyfund" -> static_path(conn, "/images/honeyfund.png")
      "Crate and Barrel" -> static_path(conn, "/images/crateandbarrel.png")
      "Amazon" -> static_path(conn, "/images/amazon.png")
    end
  end

end