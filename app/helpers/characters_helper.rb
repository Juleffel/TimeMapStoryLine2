module CharactersHelper
    def ucharacters_path(*options)
        if @user
            user_characters_path(@user, *options)
        else
            characters_path(*options)
        end
    end
    def ucharacter_path(character, *options)
        if @user
            user_character_path(@user, character, *options)
        else
            character_path(character, *options)
        end
    end
    def edit_ucharacter_path(character, *options)
        if @user
            edit_user_character_path(@user, character, *options)
        else
            edit_user_character_path(character.user, character, *options)
        end
    end
    def new_ucharacter_path(*options)
        if @user
            new_user_character_path(@user, *options)
        elsif current_user
            new_user_character_path(current_user, *options)
        else
            root_url
        end
    end
end
