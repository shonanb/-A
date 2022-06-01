class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true  
  validates :department, length: { in: 2..30 }, allow_blank: true
  validates :employee_number, length: { in: 1..4 }, allow_blank: true
  validates :card, length: { in: 1..4 }, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  validates :designated_work_start_time, presence: true
  validates :designated_work_end_time, presence: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
   # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
    # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #importメソッド
def self.import(file)
  CSV.foreach(file.path, headers: true) do |row|
    # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
    user = find_by(id: row["id"]) || new
    # CSVからデータを取得し、設定する
    user.attributes = row.to_hash.slice(*updatable_attributes)
    user.save
  end
end

# 更新を許可するカラムを定義
  def self.updatable_attributes
    ["name", "email", "department", "code", "uid", "basic_time", "basic_start_time", "basic_finish_time", "superior", "admin", "password"]
  end
end