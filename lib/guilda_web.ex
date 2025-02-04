defmodule GuildaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use GuildaWeb, :controller
      use GuildaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: GuildaWeb

      import Plug.Conn
      import GuildaWeb.Gettext
      alias GuildaWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/guilda_web/templates",
        namespace: GuildaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view(opts \\ []) do
    quote do
      opts = Keyword.merge([layout: {GuildaWeb.LayoutView, "live.html"}], unquote(opts))
      use Phoenix.LiveView, opts

      def handle_info({:flash, key, message}, socket) do
        {:noreply, put_flash(socket, key, message)}
      end

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import GuildaWeb.Components
      import GuildaWeb.Components.Badge
      import GuildaWeb.Components.Button
      import GuildaWeb.Components.Dialog
      import GuildaWeb.Components.Form
      import GuildaWeb.Components.LayoutComponents
      import GuildaWeb.Components.Link
      import GuildaWeb.ErrorHelpers
      import GuildaWeb.Gettext
      import GuildaWeb.Helpers
      import GuildaWeb.ViewHelpers

      alias GuildaWeb.InputHelpers
      alias GuildaWeb.Router.Helpers, as: Routes

      alias Phoenix.LiveView.JS
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__({which, opts}) when is_atom(which) do
    apply(__MODULE__, which, [opts])
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
