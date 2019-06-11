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

describe 'Projects#destroy',
         type: :feature,
         js: true do
  let!(:project) { FactoryBot.create(:project, name: 'foo', identifier: 'foo') }
  let(:user) { FactoryBot.create(:admin) }
  let(:projects_page) { Pages::Projects::Destroy.new(project) }
  let(:danger_zone) { DangerZone.new(page) }

  before do
    login_as user

    # Disable background worker
    allow(Delayed::Worker)
      .to receive(:delay_jobs)
      .and_return(false)

    expect(project)

    projects_page.visit!
  end

  it 'can destroy the project' do
    # Confirm the deletion
    danger_zone.confirm_with(project.identifier)
    expect(danger_zone.disabled?).to be false
    danger_zone.danger_button.click

    expect(page).to have_selector '.flash.notice', text: I18n.t('projects.delete.scheduled')

    expect { project.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
