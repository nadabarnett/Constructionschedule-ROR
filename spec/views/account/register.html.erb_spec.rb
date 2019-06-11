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

require 'spec_helper'

describe 'account/register', type: :view do
  let(:user) { FactoryBot.build :user, auth_source: nil }

  context 'with the email_login setting disabled (default value)' do
    before do
      allow(Setting).to receive(:email_login?).and_return(false)

      assign(:user, user)
      render
    end

    context 'with auth source' do
      let(:auth_source) { FactoryBot.create :auth_source }
      let(:user)        { FactoryBot.build :user, auth_source: auth_source }

      it 'should not show a login field' do
        expect(rendered).not_to include('user[login]')
      end
    end

    context 'without auth source' do
      it 'should show a login field' do
        expect(rendered).to include('user[login]')
      end
    end
  end

  context 'with the email_login setting enabled' do
    before do
      allow(Setting).to receive(:email_login?).and_return(true)

      assign(:user, user)
      render
    end

    context 'with auth source' do
      let(:auth_source) { FactoryBot.create :auth_source }
      let(:user)        { FactoryBot.build :user, auth_source: auth_source }

      it 'should not show a login field' do
        expect(rendered).not_to include('user[login]')
      end

      it 'should show an email field' do
        expect(rendered).to include('user[mail]')
      end
    end

    context 'without auth source' do
      it 'should not show a login field' do
        expect(rendered).not_to include('user[login]')
      end

      it 'should show an email field' do
        expect(rendered).to include('user[mail]')
      end
    end
  end

  context 'with the registration_footer setting enabled' do
    let(:footer) { "Some email footer" }

    before do
      allow(Setting).to receive(:registration_footer).and_return("en" => footer)

      assign(:user, user)
    end

    it 'should render the registration footer from the settings' do
      render

      expect(rendered).to include(footer)
    end

    context 'with a registration footer in the OpenProject configuration' do
      before do
        allow(OpenProject::Configuration).to receive(:registration_footer).and_return("en" => footer.reverse)
      end

      it 'should render the registration footer from the configuration, overriding the settings' do
        render

        expect(rendered).to include(footer.reverse)
      end
    end
  end
end
