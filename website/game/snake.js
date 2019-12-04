//created following https://phaser.io/phaser3/devlog/85 to learn phaser
//getting width and height of window for phaser
var gameWidth = window.innerWidth;
var gameHeight = window.innerHeight;
//basic config for a phaser object
var config = {
    type: Phaser.WEBGL,
    width: gameWidth,
    height: gameHeight,
    backgroundColor: '#777777',
    parent: 'phaser-example',
    scene: {
        preload: preload,
        create: create,
        update: update
    }
};
//snake object 
var snake;
//food object
var food;
//user input variable
var cursors;

//  Direction consts
var UP = 0;
var DOWN = 1;
var LEFT = 2;
var RIGHT = 3;

var game = new Phaser.Game(config);

function preload ()
{
    //loading game assets in
    this.load.image('food', './assets/food.png');
    this.load.image('body', './assets/body.png');
}

function create ()
{
    //creating the food object
    var Food = new Phaser.Class({

        Extends: Phaser.GameObjects.Image,

        initialize:
        //constructor
        function Food (scene, x, y)
        {
            Phaser.GameObjects.Image.call(this, scene)
            //sets the sprite for the food
            this.setTexture('food');
            //sets the location and sets it onto a 16x16 grid
            this.setPosition(x * 16, y * 16);
            this.setOrigin(0);

            this.total = 0;
            //adds itself to the scene
            scene.children.add(this);
        },
        //function for removing food
        eat: function ()
        {
            this.total++;
        }

    });
    //creating the player object
    var Snake = new Phaser.Class({

        initialize:

        function Snake (scene, x, y)
        {
            //creating geometry for snake to have sprite render properly
            this.headPosition = new Phaser.Geom.Point(x, y);

            this.body = scene.add.group();
            //sets the head onto the 16x16 grid
            this.head = this.body.create(x * 16, y * 16, 'body');
            this.head.setOrigin(0);

            //initiallizing variables
            this.alive = true;

            this.speed = 100;

            this.moveTime = 0;

            this.tail = new Phaser.Geom.Point(x, y);
            //defaults to start the player moving right
            this.heading = RIGHT;
            this.direction = RIGHT;
        },
        //deals with movement on a timer
        update: function (time)
        {
            if (time >= this.moveTime)
            {
                return this.move(time);
            }
        },
        //different functions to change the heading of the player by inputs
        faceLeft: function ()
        {
            if (this.direction === UP || this.direction === DOWN)
            {
                this.heading = LEFT;
            }
        },

        faceRight: function ()
        {
            if (this.direction === UP || this.direction === DOWN)
            {
                this.heading = RIGHT;
            }
        },

        faceUp: function ()
        {
            if (this.direction === LEFT || this.direction === RIGHT)
            {
                this.heading = UP;
            }
        },

        faceDown: function ()
        {
            if (this.direction === LEFT || this.direction === RIGHT)
            {
                this.heading = DOWN;
            }
        },
        move: function (time)
        {
            /**
            * Based on the heading property (which is the direction the pgroup pressed)
            * we update the headPosition value accordingly.
            * 
            * The Math.wrap call allow the snake to wrap around the screen, so when
            * it goes off any of the sides it re-appears on the other.
            */
            switch (this.heading)
            {
                case LEFT:
                    this.headPosition.x = Phaser.Math.Wrap(this.headPosition.x - 1, 0, gameWidth / 16);
                    break;

                case RIGHT:
                    this.headPosition.x = Phaser.Math.Wrap(this.headPosition.x + 1, 0, gameWidth / 16);
                    break;

                case UP:
                    this.headPosition.y = Phaser.Math.Wrap(this.headPosition.y - 1, 0, gameHeight / 16);
                    break;

                case DOWN:
                    this.headPosition.y = Phaser.Math.Wrap(this.headPosition.y + 1, 0, gameHeight / 16);
                    break;
            }

            this.direction = this.heading;

            //changes position of head and tail accordingly
            Phaser.Actions.ShiftPosition(this.body.getChildren(), this.headPosition.x * 16, this.headPosition.y * 16, 1, this.tail);

            //  collider check for the snake hitting itself

            var hitBody = Phaser.Actions.GetFirst(this.body.getChildren(), { x: this.head.x, y: this.head.y }, 1);

            if (hitBody)
            {
                console.log('dead');
                //kills player if collides with itself
                this.alive = false;

                return false;
            }
            else
            {
                //  Update the timer ready for the next movement
                this.moveTime = time + this.speed;

                return true;
            }
        },

        grow: function ()
        {
            //creating another body to grow the player by one
            var newPart = this.body.create(this.tail.x, this.tail.y, 'body');

            newPart.setOrigin(0);
        },
        //checking if the head of the snake is in the same space as the food
        collideWithFood: function (food)
        {
            if (this.head.x === food.x && this.head.y === food.y)
            {
                //call the grow function to add a body segment
                this.grow();
                //destroying the food 
                food.eat();

                //  For every 5 items of food eaten incease the players speed
                if (this.speed > 20 && food.total % 5 === 0)
                {
                    this.speed -= 5;
                }

                return true;
            }
            else
            {
                return false;
            }
        },

        updateGrid: function (grid)
        {
            //  Remove all body pieces from valid spawn positions list
            this.body.children.each(function (segment) {

                var bx = segment.x / 16;
                var by = segment.y / 16;

                grid[by][bx] = false;

            });

            return grid;
        }

    });
    //creates food and player at default places
    food = new Food(this, 3, 4);

    snake = new Snake(this, 8, 8);

    //  Create our keyboard controls
    cursors = this.input.keyboard.createCursorKeys();
}

function update (time, delta)
{
    if (!snake.alive)
    {
        return;
    }

    /**
    * Check which key is pressed, and then change the direction the snake
    * is heading based on that. The checks ensure you don't double-back
    * on yourself, for example if you're moving to the right and you press
    * the LEFT cursor, it ignores it, because the only valid directions you
    * can move in at that time is up and down.
    */
    if (cursors.left.isDown)
    {
        snake.faceLeft();
    }
    else if (cursors.right.isDown)
    {
        snake.faceRight();
    }
    else if (cursors.up.isDown)
    {
        snake.faceUp();
    }
    else if (cursors.down.isDown)
    {
        snake.faceDown();
    }

    if (snake.update(time))
    {
        //  If the snake updated, we need to check for collision against food

        if (snake.collideWithFood(food))
        {
            repositionFood();
        }
    }
}

/**
* We can place the food anywhere in our grid
* *except* on-top of the snake, so we need
* to filter those out of the possible food locations.
* If there aren't any locations left, they've won!
*
* @method repositionFood
* @return {boolean} true if the food was placed, otherwise false
*/
function repositionFood ()
{
    //  First creates an array that assumes all positions are valid for the new piece of food

    //  A Grid used to reposition the food each time it's eaten
    var testGrid = [];

    for (var y = 0; y < 30; y++)
    {
        testGrid[y] = [];

        for (var x = 0; x < 40; x++)
        {
            testGrid[y][x] = true;
        }
    }

    snake.updateGrid(testGrid);

    //remove false positions
    var validLocations = [];

    for (var y = 0; y < 30; y++)
    {
        for (var x = 0; x < 40; x++)
        {
            if (testGrid[y][x] === true)
            {
                //  Is this position valid for food
                validLocations.push({ x: x, y: y });
            }
        }
    }

    if (validLocations.length > 0)
    {
        //  Use the RNG to pick a random food position
        var pos = Phaser.Math.RND.pick(validLocations);

        //  place food at pos
        food.setPosition(pos.x * 16, pos.y * 16);

        return true;
    }
    else
    {
        return false;
    }
}
