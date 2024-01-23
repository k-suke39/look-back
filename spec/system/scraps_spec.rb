# frozen_string_literal: true

require 'rails_helper'

describe 'Scrap', type: :system do
  before do
    driven_by :rack_test
    @user = create(:user)
    @scrap = create(:scrap, user_id: @user.id)
    @scrap2 = create(:scrap, title: 'テストタイトル2', content: 'テスト本文2', user_id: @user.id)
  end

  let(:title) { 'テストタイトル' }
  let(:content) { 'テスト本文' }

  describe 'スクラップ投稿フォームの検証' do
    subject do
      fill_in 'scrap_title', with: title
      fill_in 'scrap_content', with: content
      click_button 'ログを記録'
    end
    context 'ログインしていない場合' do
      before { visit 'scraps/new' }
      it 'ログインページにリダイレクトされる' do
        expect(current_path).to eq('/users/sign_in')
        expect(page).to have_content('ログインしてください。')
      end
    end
    context 'ログイン済みの場合' do
      before do
        sign_in @user
        visit 'scraps/new'
      end
      it 'ログインページにリダイレクトされない' do
        expect(current_path).not_to eq('users/sign_in')
      end
      context '正常系' do
        it 'Scrapを作成できる' do
          expect { subject }.to change { Scrap.count }.by(1)
          expect(current_path).to eq('/scraps')
          expect(page).to have_content('記録しました')
        end
      end
      context '異常系' do
        context 'titleが空の場合' do
          let(:title) { '' }
          it 'Scrapを作成できない' do
            expect { subject }.to change { Scrap.count }.by(0)
            expect(page).to have_content('記録に失敗しました')
          end

          it 'フォームに入力していた内容は保持される' do
            subject
            expect(page).to have_field('scrap_content', with: content)
          end
        end
      end
    end
  end

  describe 'スクラップ詳細機能の検証' do
    before { visit "scraps/#{@scrap.id}" }
    it '詳細データが表示される' do
      expect(page).to have_content('テストタイトル')
      expect(page).to have_content('テスト本文')
      expect(page).to have_content(@user.nickname)
    end
  end

  describe 'スクラップ一覧機能の検証' do
    before { visit '/scraps' }

    context '正常系' do
      it '1件目のScrapが表示される' do
        expect(page).to have_content('テストタイトル')
        expect(page).to have_content('テスト本文')
        expect(page).to have_content(@user.nickname)
      end

      it '2件目のScrapが表示される' do
        expect(page).to have_content('テストタイトル2')
        expect(page).to have_content('テスト本文2')
        expect(page).to have_content(@user.nickname)
      end

      it 'タイトルをクリックすると詳細ページへ遷移する' do
        click_link 'テストタイトル'
        expect(current_path).to eq("/scraps/#{@scrap.id}")
      end

      it '編集するを押下すると編集ページに遷移できる' do
        sign_in @user
        visit '/scraps'
        all('a', text: '編集する').last.click
        expect(current_path).to eq("/scraps/#{@scrap.id}/edit")
      end

      context 'ログインユーザーではない時' do
        let(:other_user) { create(:user) }
        it '編集するボタンが表示されない' do
          sign_in other_user
          visit '/scraps'
          expect(page).not_to have_content('編集する')
        end
      end
    end
  end

  describe 'スクラップ編集機能の検証' do
    before { visit "/scraps/#{@scrap.id}/edit" }
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        expect(current_path).to eq('/users/sign_in')
        expect(page).to have_content('ログインしてください。')
      end
    end
    context 'ログイン済みの場合' do
      before do
        sign_in @user
        visit "/scraps/#{@scrap.id}/edit"
      end

      it 'ログインページにリダイレクトされない' do
        expect(current_path).not_to eq('/users/sign_in')
      end

      subject do
        fill_in 'scrap_title', with: "#{title}hoge"
        fill_in 'scrap_content', with: "#{content}hoge"
        click_button 'ログを更新'
      end

      context '正常系' do
        it 'Scrapが更新される' do
          original_title = @scrap.title
          original_content = @scrap.content

          subject

          updated_scrap = Scrap.find(@scrap.id)

          expect(updated_scrap.title).to eq("#{original_title}hoge")
          expect(updated_scrap.content).to eq("#{original_content}hoge")
        end

        it '一覧ページに遷移される' do
          subject
          expect(current_path).to eq('/scraps')
        end
      end

      context '異常系' do
        subject do
          fill_in 'scrap_title', with: title.to_s
          fill_in 'scrap_content', with: content.to_s
          click_button 'ログを更新'
        end

        context 'titleが空の場合' do
          let(:title) { '' }
          it 'Scrapを作成できない' do
            subject
            expect(page).to have_content('記録の更新に失敗しました')
          end

          it 'フォームに入力していた内容は保持される' do
            subject
            expect(page).to have_field('scrap_content', with: @scrap.content)
          end
        end
      end
    end
  end
end
