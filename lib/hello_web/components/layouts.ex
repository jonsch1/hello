defmodule HelloWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use HelloWeb, :controller` and
  `use HelloWeb, :live_view`.
  """
  use HelloWeb, :html

  import SaladUI.DropdownMenu
  import SaladUI.Menu
  alias SaladUI.Icon, as: SaladIcon
  alias SaladUI.Button, as: SaladButton
  import SaladUI.Dialog
  import SaladUI.Input
  import SaladUI.Label

  embed_templates "layouts/*"
end
