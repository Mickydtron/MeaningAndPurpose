class MeaningAndPurpose.Routers.Questions extends Backbone.Router
	routes:
		"(#)graphs(/user)(/)": "user_graph"
		"(#)": "quiz"
	quiz: ->
		# console.log 'router.quiz'
		# Set Application State
		# Get user_id, Quiz, and Questions from gon
		unless gon? and gon.questions? and gon.quiz?
			$.ajax("/app/home.json", {success: (result, status, xhr) ->
				# console.log 'router.quiz ajax'
				window.gon = result
				MeaningAndPurpose.router.init_quiz()
			})
		else
			this.init_quiz()
	user_graph: ->
		# console.log 'router.user_graph'
		unless gon? and gon.questions? and gon.data?
			$.ajax("/graphs/user.json", {success: (result, status, xhr) ->
				window.gon = result
				MeaningAndPurpose.router.init_user_graph()
			})
		else
			this.init_user_graph()
	init_quiz: ->
		# console.log 'init_quiz'
		MeaningAndPurpose.State.questions = new MeaningAndPurpose.Collections.Questions(gon.questions)
		MeaningAndPurpose.State.quiz = new MeaningAndPurpose.Models.Quiz(gon.quiz)
		MeaningAndPurpose.State.user_id = gon.current_user.id
		# Match the response to the quiz
		MeaningAndPurpose.State.response = new MeaningAndPurpose.Models.Response()
		MeaningAndPurpose.State.response.set("quiz_id", MeaningAndPurpose.State.quiz.get("id"))
		MeaningAndPurpose.State.response.set("user_id", MeaningAndPurpose.State.user_id)
		# Create an answer for each question
		answerFactory = (question_id) ->
			answer = new MeaningAndPurpose.Models.Answer()
			answer.set({"question_id": question_id})
			answer
		answerModels = (answerFactory(question.get("id")) for question in MeaningAndPurpose.State.questions.models)
		MeaningAndPurpose.State.answers = new MeaningAndPurpose.Collections.Answers(answerModels)
		# Make the Quiz view
		pageView = new MeaningAndPurpose.Views.QuestionsIndex {}
		$('body').html(pageView.render().$el)
	init_user_graph: ->
		# Get state from gon
		MeaningAndPurpose.State.questions = new MeaningAndPurpose.Collections.Questions(gon.questions)
		MeaningAndPurpose.State.user_graph_data = gon.data
		MeaningAndPurpose.State.graph = new MeaningAndPurpose.Models.UserGraph({activeQuestion: -1})
		userGraphView = new MeaningAndPurpose.Views.GraphsUser {}
		$('body').html(userGraphView.render().$el)
		userGraphView.renderChart()
