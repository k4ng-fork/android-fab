express = require('express')
rfr = require('rfr')
auth = rfr('./helpers/auth')
CategoryManager = rfr('./managers/categories')
router = express.Router()

router.get('/', auth.checkAndRefuse, (req, res, next) ->
	CategoryManager.getCategories(true, (err, categories) ->
		if (err)
			return next(err)

		res.render('settings/categories/index', {
			_: {
				title: 'Settings: Categories'
				activePage: 'settings-categories'
			},
			categories: categories
		})
	)
)

router.get('/create', auth.checkAndRefuse, (req, res) ->
	res.render('settings/categories/edit', {
		_: {
			title: 'Settings: Create Category'
			activePage: 'settings-categories'
		}
	})
)

router.get('/edit/:categoryId', auth.checkAndRefuse, (req, res) ->
	categoryId = req.params['categoryId']

	CategoryManager.getCategory(categoryId, (err, category) ->
		if (err or !category)
			req.flash('error', 'Sorry, that category couldn\'t be loaded!')
			res.writeHead(302, { Location: '/settings/categories' })
			res.end()
			return

		res.render('settings/categories/edit', {
			_: {
				title: 'Settings: Edit Category'
				activePage: 'settings-categories'
			},
			category: category
		})
	)
)

router.post('/edit/:categoryId', auth.checkAndRefuse, (req, res) ->
	categoryId = req.params['categoryId']
	category = req.body

	CategoryManager.saveCategory(categoryId, category, (err) ->
		if (err)
			req.flash('error', 'Sorry, that category couldn\'t be saved!')

		res.writeHead(302, { Location: '/settings/categories' })
		res.end()
	)
)

module.exports = router