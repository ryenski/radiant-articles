module UserMethods
    has_many :departments_users
    has_many :departments, :through => :departments_users
end