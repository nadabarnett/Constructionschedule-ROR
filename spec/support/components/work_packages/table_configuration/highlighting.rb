#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

module Components
  module WorkPackages
    class Highlighting
      include Capybara::DSL
      include RSpec::Matchers

      def initialize; end

      def switch_highlighting_mode(label)
        modal_open? or open_modal
        choose label

        apply
      end

      def switch_entire_row_highlight(label)
        modal_open? or open_modal
        choose "Entire row by"
        page.all(".form--field")[1].select label
        apply
      end

      def switch_inline_attribute_highlight(*labels)
        modal_open? or open_modal
        choose "Highlighted attribute(s)"
        within(page.all(".form--field")[0]) do
          if labels.size == 1
            select labels.first
          elsif labels.size > 1
            find('[class*="--toggle-multiselect"]').click
            labels.each do |label|
              select label
            end
          end
        end
        apply
      end

      def apply
        @opened = false

        click_button('Apply')
      end

      def open_modal
        @opened = true
        ::Components::WorkPackages::TableConfigurationModal.new.open_and_switch_to 'Highlighting'
      end

      def assume_opened
        @opened = true
      end

      private

      def within_modal
        page.within('.wp-table--configuration-modal') do
          yield
        end
      end

      def modal_open?
        !!@opened
      end
    end
  end
end
