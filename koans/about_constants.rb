require File.expand_path(File.dirname(__FILE__) + '/neo')

C = "top level"

class AboutConstants < Neo::Koan

  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal "nested", C
  end

  # Top-Level ::CONSTANTS

  def test_top_level_constants_are_referenced_by_double_colons
    assert_equal "top level", ::C
  end

  # Use :: with Class Name for complete path

  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal "nested", AboutConstants::C
    assert_equal "nested", ::AboutConstants::C
  end

  # ------------------------------------------------------------------

  # INHERITANCE

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal 4, Reptile.new.legs_in_reptile
  end

  # ------------------------------------------------------------------

  # NESTED CLASSES behave differently!

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?
  # The Constant in Lexical Scope has precedence, even though Bird is
  # inheriting from a different class.

  # ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?
  # I had to think about this one for a bit.. I think it has something to
  # do with how the Oyster class is defined in MyAnimals, and to confirm
  # this assumption, I found this great answer on Stack Overflow via @bowsersenior

  # I was just pondering the very same question from the very same koan. I am no expert
  # at scoping, but the following simple explanation made a lot of sense to me, and maybe it will help you as well.

  # When you define MyAnimals::Oyster you are still in the global scope, so ruby has no knowledge of the LEGS
  # value set to 2 in MyAnimals because you never actually are in the scope of MyAnimals (a little counterintuitive).

  # However, things would be different if you were to define Oyster this way:

  # class MyAnimals
  #   class Oyster < Animal
  #     def legs_in_oyster
  #       LEGS # => 2
  #     end
  #   end
  # end

  # The difference is that in the code above, by the time you define Oyster, you have dropped into the scope
  # of MyAnimals, so ruby knows that LEGS refers to MyAnimals::LEGS (2) and not Animal::LEGS (4).
end
